<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\Controller;

use CRM\App\Controller\BaseController;

class QuickView extends BaseController
{
    public function modalAction($request)
    {
        return $this->render('', [
            'todos'   => $this->repo('Todo', 'Calendar')->allToDoWithDetails(),
            'events'  => $this->repo('Event', 'Calendar')->getNearlyEvents(null, '+ 1 day'),
            'repo'    => $this->repo('Event')
        ]);
    }
}
