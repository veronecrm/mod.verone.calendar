<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\ORM;

use CRM\ORM\Repository;

class TodoRepository extends Repository
{
    public $dbTable = '#__calendar_todo';

    public function find($pk)
    {
        $result = parent::find($pk);

        if(! $result)
        {
            return false;
        }

        if($result->getUserFor() == $this->user()->getId() || $result->getUserFrom() == $this->user()->getId())
        {
            return $result;
        }

        return false;
    }

    public function all()
    {
        return parent::selectQuery('SELECT * FROM '.$this->dbTable.' WHERE userFor = '.$this->user()->getId().' ORDER BY ordering ASC');
    }

    public function allToDo()
    {
        return parent::selectQuery('SELECT * FROM '.$this->dbTable.' WHERE userFor = '.$this->user()->getId().' AND todo = 1 ORDER BY ordering ASC');
    }

    public function allForEdit()
    {
        return parent::selectQuery('SELECT * FROM '.$this->dbTable.' WHERE userFor = '.$this->user()->getId().' OR userFrom = '.$this->user()->getId().' ORDER BY ordering ASC');
    }

    public function allWithDetails()
    {
        $todos = $this->all();

        foreach($todos as $todo)
        {
            $this->collectDetails($todo);
        }

        return $todos;
    }

    public function allToDoWithDetails()
    {
        $todos = $this->all();

        foreach($todos as $todo)
        {
            $this->collectDetails($todo);
        }

        return $todos;
    }

    /*public function countAll()
    {
        $result = $this->db()->query('SELECT COUNT(id) AS count FROM '.$this->dbTable.' WHERE userFor = '.$this->user()->getId().' LIMIT 1');

        if(isset($result[0]['count']))
        {
            return $result[0]['count'];
        }
        else
        {
            return 0;
        }
    }*/

    public function countNotDone()
    {
        $result = $this->db()->query('SELECT COUNT(id) AS count FROM '.$this->dbTable.' WHERE userFor = '.$this->user()->getId().' AND `done` = 0 LIMIT 1');

        if(isset($result[0]['count']))
        {
            return $result[0]['count'];
        }
        else
        {
            return 0;
        }
    }

    public function collectDetails(Todo $todo)
    {
        $user = $this->repo('User', 'User')->find($todo->getUserFrom());

        if(! $user)
        {
            $user = $this->entity('User', 'User');
        }

        $todo->setUserFrom($user);

        $user = $this->repo('User', 'User')->find($todo->getUserFor());

        if(! $user)
        {
            $user = $this->entity('User', 'User');
        }

        $todo->setUserFor($this->repo('User', 'User')->find($todo->getUserFor()));

        return $todo;
    }
}
