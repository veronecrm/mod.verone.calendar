<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\ORM;

use CRM\ORM\Repository;

class EventRepository extends Repository
{
    public $dbTable = '#__calendar_event';

    public function find($pk)
    {
        $result = parent::find($pk);

        if(! $result)
        {
            return false;
        }

        if($result->getOwner() == $this->user()->getId())
        {
            return $result;
        }

        return false;
    }

    public function all()
    {
        return parent::selectQuery('SELECT * FROM '.$this->dbTable.' WHERE owner = '.$this->user()->getId());
    }

    /**
     * @todo Optimalization. Calculate range between current time and time
     *       of event, and calculate how much days/weeks/months/years has passed
     *       between this values, and call one time strtotime fn, instead of
     *       multiple times, for every interval. I.e. first call
     *       strtotime('+ 4 weeks'), and then, in do...while loop, call
     *       every time, for every interval, like now. One call for 4 weeks, is
     *       quickly, than calls 4 times, for 1 week.
     */
    public function allFromRange($from, $to)
    {
        $events   = parent::selectQuery('SELECT * FROM '.$this->dbTable.' WHERE owner = '.$this->user()->getId().' AND `start` >= '.$from.' AND `start` <= '.$to.' AND `repeat` = 0 ORDER BY `start` ASC');
        $repeated = parent::selectQuery('SELECT * FROM '.$this->dbTable.' WHERE owner = '.$this->user()->getId().' AND `repeat` = 1 AND `start` <= '.$to.' ORDER BY `start` ASC');

        foreach($repeated as $event)
        {
            $checkFrom = $event->getStart();
            $checkTo   = $event->getEnd();

            if($checkFrom >= $from && $checkFrom <= $to)
            {
                $events[] = clone $event;
            }

            // For 2 days
            if($event->getRepeatType() == 2)
            {
                $interval = '+ 2 days';
            }
            // Weekly
            elseif($event->getRepeatType() == 3)
            {
                $interval = '+ 1 week';
            }
            // For 2 weeks
            elseif($event->getRepeatType() == 4)
            {
                $interval = '+ 2 weeks';
            }
            // Monthly
            elseif($event->getRepeatType() == 5)
            {
                $interval = '+ 1 month';
            }
            // For 3 months
            elseif($event->getRepeatType() == 6)
            {
                $interval = '+ 3 months';
            }
            // For 6 months
            elseif($event->getRepeatType() == 7)
            {
                $interval = '+ 6 months';
            }
            // Yearly
            elseif($event->getRepeatType() == 8)
            {
                $interval = '+ 1 year';
            }
            // Daily
            else
            {
                $interval = '+ 1 day';
            }

            do {
                $checkFrom = strtotime($interval, $checkFrom);
                $checkTo   = strtotime($interval, $checkTo);

                if($checkFrom >= $from && $checkFrom <= $to)
                {
                    $new = clone $event;
                    $new->setStart($checkFrom);
                    $new->setEnd($checkTo);

                    $events[] = $new;
                }
            }
            while($checkFrom <= $to);
        }

        return $events;
    }

    public function allFromWeek()
    {
        $end  = time() + (60 * 60 * 24 * 6);
        $from = mktime(0, 0, 0, date('m'), date('d'), date('Y'));
        $to   = mktime(23, 59, 0, date('m', $end), date('d', $end), date('Y', $end));

        return $this->allFromRange($from, $to);
    }

    public function allFromToday()
    {
        $from = mktime(0, 0, 0, date('m'), date('d'), date('Y'));
        $to   = mktime(23, 59, 0, date('m'), date('d'), date('Y'));

        return $this->allFromRange($from, $to);
    }

    public function prepareEventForJS(Event $event, $asJSON = false)
    {
        $result = [];

        $result['title']  = $event->getName();
        //$result['allday'] = $event->getAllday();

        /*if($event->getAllday())
        {
            $result['start'] = date('Y-m-d', $event->getStart());
            $result['startHuman'] = $this->datetime()->dateShort($event->getStart());
        }
        else
        {*/
            $result['start'] = date('Y-m-d\TH:i:00', $event->getStart());
            $result['end']   = date('Y-m-d\TH:i:00', $event->getEnd());
            $result['startHuman'] = $this->datetime($event->getStart());
        /*}*/

        $color = $this->getEventColorByType($event->getType());

        $result['color'] = $color['color'];
        $result['typeName'] = $color['name'];
        $result['id'] = $event->getId();
        $result['description'] = $event->getDescription();
        $result['editable'] = true;

        return $asJSON ? json_encode($result) : $result;
    }

    public function getFromRangeEvented($from, $to, array $filters = [])
    {
        $result = [];

        foreach($this->callPlugins('Calendar', 'eventsFromRange', [ $from, $to ]) as $module)
        {
            $result = is_array($module) ? array_merge($result, $module) : $result;
        }

        $color = $this->repo('Event', 'Calendar')->getEventColorByType(0);

        $defaultEvent = [
            'group'       => '',
            'title'       => '',
            'start'       => date('Y-m-d'),
            'startHuman'  => $this->datetime()->dateShort(time()),
            'color'       => $color['color'],
            'typeName'    => $color['name'],
            'id'          => '',
            'editable'    => false,
            'description' => '',
            'onClickRedirect' => false
        ];

        foreach($result as $key => $val)
        {
            $result[$key] = array_merge($defaultEvent, $val);
        }

        if($filters !== [])
        {
            foreach($result as $key => $val)
            {
                if(! in_array($val['group'], $filters))
                {
                    unset($result[$key]);
                }
            }
        }

        return array_values($result);
    }

    public function getNearlyEvents($filters = null, $period = null)
    {
        if($filters === null)
        {
            $filters = explode(',', $this->openSettings('user')->get('mod.calendar.filters'));
        }

        if($period === null)
        {
            $period = '+ 1 week';
        }

        $toDate  = strtotime($period);
        $from    = mktime(0, 0, 0, date('m'), date('d'), date('Y'));
        $to      = mktime(0, 0, 0, date('m', $toDate), date('d', $toDate), date('Y', $toDate));

        $events  = $this->getFromRangeEvented($from, $to, $filters);

        // Create timestamp for every event
        foreach($events as $key => $event)
        {
            $events[$key]['start-timestamp'] = $this->parseDate($event['start']);
            
            if(isset($event['end']))
                $events[$key]['end-timestamp'] = $this->parseDate($event['end']);
            else
                $events[$key]['end-timestamp'] = 0;
        }

        usort($events, function($a, $b) {
            if($a['start-timestamp'] == $b['start-timestamp'])
                return 0;
            else
                return ($a['start-timestamp'] < $b['start-timestamp']) ? -1 : 1;
        });

        return $events;
    }

    public function parseDate($date)
    {
        $det = date_parse($date.':00');

        return mktime($det['hour'], $det['minute'], $det['second'], $det['month'], $det['day'], $det['year']);
    }

    public function getEventsTypesColors()
    {
        return [
            [
                'id' => 0,
                'name' => 'Inne',
                'color' => '#0088CC'
            ],
            [
                'id' => 1,
                'name' => 'Spotkanie',
                'color' => '#29B12B'
            ],
            [
                'id' => 2,
                'name' => 'Do zrobienia',
                'color' => '#D9534F'
            ]
        ];
    }

    public function getEventColorByType($type)
    {
        foreach($this->getEventsTypesColors() as $item)
        {
            if($item['id'] == $type)
            {
                return $item;
            }
        }

        return [
            'id' => 0,
            'name' => '---',
            'color' => '#0088CC'
        ];
    }
}
