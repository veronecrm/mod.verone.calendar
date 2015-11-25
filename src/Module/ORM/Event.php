<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\ORM;

use CRM\ORM\Entity;

class Event extends Entity
{
    protected $id;
    protected $owner;
    protected $name;
    protected $description;
    protected $start;
    protected $end;
    protected $repeat;
    protected $repeatType;
    protected $type;

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
     * Gets the value of owner.
     *
     * @return mixed
     */
    public function getOwner()
    {
        return $this->owner;
    }

    /**
     * Sets the value of owner.
     *
     * @param mixed $owner the owner
     *
     * @return self
     */
    public function setOwner($owner)
    {
        $this->owner = $owner;

        return $this;
    }

    /**
     * Gets the value of name.
     *
     * @return mixed
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * Sets the value of name.
     *
     * @param mixed $name the name
     *
     * @return self
     */
    public function setName($name)
    {
        $this->name = $name;

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
     * Gets the value of start.
     *
     * @return mixed
     */
    public function getStart()
    {
        return $this->start;
    }

    /**
     * Sets the value of start.
     *
     * @param mixed $start the start
     *
     * @return self
     */
    public function setStart($start)
    {
        $this->start = $start;

        return $this;
    }

    /**
     * Gets the value of end.
     *
     * @return mixed
     */
    public function getEnd()
    {
        return $this->end;
    }

    /**
     * Sets the value of end.
     *
     * @param mixed $end the end
     *
     * @return self
     */
    public function setEnd($end)
    {
        $this->end = $end;

        return $this;
    }

    /**
     * Gets the value of repeat.
     *
     * @return mix
     */
    public function getRepeat()
    {
        return $this->repeat;
    }

    /**
     * Sets the value of repeat.
     *
     * @param mix $repeat the repeat
     *
     * @return self
     */
    public function setRepeat($repeat)
    {
        $this->repeat = $repeat;

        return $this;
    }

    /**
     * Gets the repeatType.
     *
     * @return mixed
     */
    public function getRepeatType()
    {
        return $this->repeatType;
    }

    /**
     * Sets the $repeatType.
     *
     * @param mixed $repeatType the repeat type
     *
     * @return self
     */
    public function setRepeatType($repeatType)
    {
        $this->repeatType = $repeatType;

        return $this;
    }

    /**
     * Gets the value of type.
     *
     * @return mixed
     */
    public function getType()
    {
        return $this->type;
    }

    /**
     * Sets the value of type.
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
}
