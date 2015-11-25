<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Contractor\ORM;

use CRM\ORM\Repository;

class ContractorRepository extends Repository
{
    public $dbTable = '#__contractor';

    public function findAll($conditions = '', array $binds = [], $start = null, $limit = null)
    {
        $pagination = '';

        if($start !== null && $limit !== null)
        {
            $pagination = "LIMIT $start, $limit";
        }

        if($conditions != '')
        {
            $conditions = "WHERE {$conditions}";
        }

        return $this->doPostSelect($this->prepareAndExecute("SELECT * FROM `{$this->dbTable}` {$conditions} {$pagination} ORDER BY name ASC", $binds, true));
    }

    public function findAllByEmail($email)
    {
        return $this->selectQuery("SELECT * FROM `{$this->dbTable}` WHERE email = :email", [ 'email' => $email ]);
    }
}
