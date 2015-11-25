<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\ORM;

use CRM\ORM\Entity;

class Todo extends Entity
{
    protected $id;
    protected $userFrom;
    protected $userFor;
    protected $date;
    protected $priority;
    protected $done;
    protected $type;
    protected $description;
    protected $ordering;

    /**
     * Gets the value of id.
     *
     * @return mixed
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Sets the value of id.
     *
     * @param mixed $id the id
     *
     * @return self
     */
    public function setId($id)
    {
        $this->id = $id;

        return $this;
    }

    /**
     * Gets the value of userFrom.
     *
     * @return mixed
     */
    public function getUserFrom()
    {
        return $this->userFrom;
    }

    /**
     * Sets the value of userFrom.
     *
     * @param mixed $userFrom the user from
     *
     * @return self
     */
    public function setUserFrom($userFrom)
    {
        $this->userFrom = $userFrom;

        return $this;
    }

    /**
     * Gets the value of userFor.
     *
     * @return mixed
     */
    public function getUserFor()
    {
        return $this->userFor;
    }

    /**
     * Sets the value of userFor.
     *
     * @param mixed $userFor the user for
     *
     * @return self
     */
    public function setUserFor($userFor)
    {
        $this->userFor = $userFor;

        return $this;
    }

    /**
     * Gets the value of date.
     *
     * @return mixed
     */
    public function getDate()
    {
        return $this->date;
    }

    /**
     * Sets the value of date.
     *
     * @param mixed $date the date
     *
     * @return self
     */
    public function setDate($date)
    {
        $this->date = $date;

        return $this;
    }

    /**
     * Gets the value of priority.
     *
     * @return mixed
     */
    public function getPriority()
    {
        return $this->priority;
    }

    public function getPriorityClassName()
    {
        $priorities = ['secondary', 'primary', 'warning', 'danger'];

        return $priorities[$this->priority];
    }

    /**
     * Sets the value of priority.
     *
     * @param mixed $priority the priority
     *
     * @return self
     */
    public function setPriority($priority)
    {
        $this->priority = $priority;

        return $this;
    }

    /**
     * Gets the value of done.
     *
     * @return mixed
     */
    public function getDone()
    {
        return $this->done;
    }

    /**
     * Sets the value of done.
     *
     * @param mixed $done the done
     *
     * @return self
     */
    public function setDone($done)
    {
        $this->done = $done;

        return $this;
    }

    /**
     * Gets the type.
     *
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Sets the $type.
     *
     * @param mixed $type the type
     *
     * @return self
     */
    public function setType($type)
    {
        $this->type = $type;

        return $this;
    }

    /**
     * Gets the value of description.
     *
     * @return mixed
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * Sets the value of description.
     *
     * @param mixed $description the description
     *
     * @return self
     */
    public function setDescription($description)
    {
        $this->description = $description;

        return $this;
    }

    /**
     * Gets the value of ordering.
     *
     * @return mixed
     */
    public function getOrdering()
    {
        return $this->ordering;
    }

    /**
     * Sets the value of ordering.
     *
     * @param mixed $ordering the ordering
     *
     * @return self
     */
    public function setOrdering($ordering)
    {
        $this->ordering = $ordering;

        return $this;
    }
}
