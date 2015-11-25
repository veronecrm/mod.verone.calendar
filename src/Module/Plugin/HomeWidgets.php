<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\Plugin;

use CRM\App\Module\Plugin;

class HomeWidgets extends Plugin
{
    public function widgetsGet()
    {
        $count = $this->repo('Todo', 'Calendar')->countNotDone();

        return [
            [
                'id' => 'widget-calendar-todo',
                'content' => '<div class="widget-head"><div class="buttons-group"><a href="'.$this->createUrl('Calendar', 'Todo', 'add').'" class="btn"><i class="fa fa-plus"></i></a><button class="btn widget-options" type="button"><i class="fa fa-cog"></i></button></div><h2>'.$this->t('calendarTodos').($count == 0 ? '' : ' (<span>'.$count.'</span>)').'</h2></div><div class="widget-body">'.$this->get('templating.engine')->render('todoList.HomeWidgets.Calendar', ['todos' => $this->repo('Todo', 'Calendar')->allToDoWithDetails()]).'</div>'
            ],
            [
                'id' => 'widget-calendar-notes',
                'content' => $this->get('templating.engine')->render('notes.HomeWidgets.Calendar')
            ],
            [
                'id' => 'widget-calendar-calendar',
                'content' => $this->get('templating.engine')->render('events.HomeWidgets.Calendar', [
                    'events' => $this->repo('Event', 'Calendar')->getNearlyEvents(null, '+ 1 day')
                ])
            ]
        ];
    }
}
