<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\Controller;

use CRM\App\Controller\BaseController;

class Calendar extends BaseController
{
    public function indexAction($request)
    {
        $groups = [];

        foreach($this->callPlugins('Calendar', 'eventsGroups') as $module)
        {
            $groups = is_array($module) ? array_merge($groups, $module) : $groups;
        }

        array_multisort($groups);

        return $this->render('', [
            'repo'    => $this->repo('Event'),
            'filters' => explode(',', $this->openSettings('user')->get('mod.calendar.filters')),
            'eventsGroups' => $groups
        ]);
    }

    public function listEventsAction($request)
    {
        return $this->responseAJAX([
            'status' => 'success',
            'data'   => $this->repo('Event')->getFromRangeEvented($request->get('from', 0), $request->get('to', 0), explode(',', $request->get('filters')))
        ]);
    }

    public function nearlyEventsAction($request)
    {
        $filters = explode(',', $request->get('filters'));
        $events  = $this->repo('Event')->getNearlyEvents($filters);

        return $this->render('eventsList.Parts.Calendar', [
            'events' => $events
        ]);
    }

    public function saveAction($request)
    {
        $repo  = $this->repo('Event');
        $event = $this->entity('Event')->fillFromRequest($request);
        $event->setOwner($this->user()->getId());
        $event->setStart($repo->parseDate($event->getStart()));
        $event->setEnd($repo->parseDate($event->getEnd()));

        $repo->save($event);

        return $this->responseAJAX([
            'status'  => 'success',
            'data'    => $repo->prepareEventForJS($event)
        ]);
    }

    public function getAction($request)
    {
        $repo  = $this->repo('Event');
        $event = $repo->find($request->get('id'));

        if(! $event)
        {
            return $this->responseAJAX([
                'status' => 'error',
                'message' => $this->t('calendarEventDoesntExists')
            ]);
        }

        // We have to format dates for jQuery plugin
        $event->setStart(date('Y-m-d H:i', $event->getStart()));
        $event->setEnd(date('Y-m-d H:i', $event->getEnd()));

        return $this->responseAJAX([
            'status' => 'success',
            'message' => '',
            'data' => $event->exportToArray()
        ]);
    }

    public function updateAction($request)
    {
        $repo  = $this->repo('Event');
        $event = $repo->find($request->get('id'));

        if(! $event)
        {
            return $this->responseAJAX([
                'status' => 'error',
                'message' => $this->t('calendarEventDoesntExists')
            ]);
        }

        $event->fillFromRequest($request);

        if($request->request->has('start'))
        {
            $event->setStart($repo->parseDate($event->getStart()));
        }
        if($request->request->has('end'))
        {
            $event->setEnd($repo->parseDate($event->getEnd()));
        }

        $repo->save($event);

        return $this->responseAJAX([
            'status' => 'success',
            'message' => $this->t('calendarEventUpdated'),
            'data' => $event->exportToArray()
        ]);
    }

    public function deleteAction($request)
    {
        $repo  = $this->repo('Event');
        $event = $repo->find($request->get('id'));

        if(! $event)
        {
            return $this->responseAJAX([
                'status' => 'error',
                'message' => $this->t('calendarEventDoesntExists')
            ]);
        }

        $repo->delete($event);

        return $this->responseAJAX([
            'status' => 'success',
            'message' => $this->t('calendarEventDeleted')
        ]);
    }

    public function updateFiltersAction($request)
    {
        $this->openSettings('user')->set('mod.calendar.filters', $request->get('filters'));

        return $this->responseAJAX([
            'status' => 'success',
            'message' => ''
        ]);
    }
}
