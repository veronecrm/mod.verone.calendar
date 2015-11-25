<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\Plugin;

use CRM\App\Module\Plugin;

class Calendar extends Plugin
{
    public function eventsFromRange($from, $to)
    {
        $repo = $this->repo('Event', 'Calendar');
        $list = $repo->allFromRange($from, $to);
        $result = [];

        foreach($list as $event)
        {
            $result[] = $repo->prepareEventForJS($event);
        }

        return $result;
    }

    public function updateEvent($id, $group, array $data)
    {

    }
}
