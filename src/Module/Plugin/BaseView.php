<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\Plugin;

use CRM\App\Module\Plugin;

class BaseView extends Plugin
{
    public function navbarLinks()
    {
        $this->assetter()->load([
            'files' => [ 'js' => [ '{ROOT}/modules/Calendar/app.mod.calendar.todos.js' ] ]
        ]);

        $count = $this->repo('Todo', 'Calendar')->countNotDone();

        return '<li><a href="#" class="mod-calendar-quickview-show"><span class="badge"'.($count ? '' : ' style="display:none"').'>'.$count.'</span><i class="fa fa-calendar fa-fw"></i></a></li>';
    }
}
