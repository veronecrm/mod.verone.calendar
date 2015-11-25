<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

namespace App\Module\Calendar\Controller;

use CRM\App\Controller\BaseController;

class Todo extends BaseController
{
    public function indexAction()
    {
        return $this->render('', [
            'elements' => $this->repo('Todo', 'Calendar')->allForEdit()
        ]);
    }

    public function addAction()
    {
        $todo = $this->entity('Todo');
        $todo->setType(1);
        $todo->setPriority(1);

        return $this->render('form', [
            'users' => $this->repo('User', 'User')->all(),
            'todo'  => $todo
        ]);
    }

    public function saveAction($request)
    {
        $todo = $this->entity('Todo')->fillFromRequest($request);
        $todo->setUserFrom($this->user()->getId());
        $todo->setDate(time());

        $this->repo('Todo')->save($todo);

        $this->flash('success', $this->t('calendarTodoSaved'));

        return $this->redirect('Calendar', 'Todo', 'index');
    }

    public function editAction($request)
    {
        $todo = $this->repo('Todo')->find($request->get('id'));

        if(! $todo)
        {
            $this->flash('danger', $this->t('calendarTodoDoesntExists'));
            return $this->redirect('Calendar', 'Todo', 'index');
        }

        return $this->render('form', [
            'todo'  => $todo,
            'users' => $this->repo('User', 'User')->all()
        ]);
    }

    public function updateAction($request)
    {
        $todo = $this->repo('Todo')->find($request->get('id'));

        if(! $todo)
        {
            $this->flash('danger', $this->t('calendarTodoDoesntExists'));
            return $this->redirect('Calendar', 'Todo', 'index');
        }

        $todo->fillFromRequest($request);

        $this->repo('Todo')->save($todo);

        $this->flash('success', $this->t('calendarTodoSaved'));

        return $this->redirect('Calendar', 'Todo', 'index');
    }

    public function deleteAction($request)
    {
        $todo = $this->repo('Todo')->find($request->get('id'));

        if(! $todo)
        {
            if($request->isAjax())
            {
                return $this->responseAJAX([
                    'status' => 'danger',
                    'message' => $this->t('calendarTodoDoesntExists')
                ]);
            }
            else
            {
                $this->flash('danger', $this->t('calendarTodoDoesntExists'));
                return $this->redirect('Calendar', 'Todo', 'index');
            }
        }

        $this->repo('Todo')->delete($todo);

        if($request->isAjax())
        {
            return $this->responseAJAX([
                'status' => 'success',
                'message' => $this->t('calendarTodoDeletedSuccess')
            ]);
        }
        else
        {
            $this->flash('success', $this->t('calendarTodoDeletedSuccess'));
            return $this->redirect('Calendar', 'Todo', 'index');
        }
    }

    public function sortableAction($request)
    {
        $elements = (array) $request->get('linr');
        $repo     = $this->repo('Todo');

        foreach($elements as $no => $id)
        {
            $todo = $repo->find($id);

            if($todo)
            {
                $todo->setOrdering($no + 1);
                $repo->save($todo);
            }
        }

        return $this->response('OK');
    }

    public function doneToggleAction($request)
    {
        $todo = $this->repo('Todo')->find($request->get('id'));

        if(! $todo)
        {
            return $this->responseAJAX([
                'status' => 'danger',
                'message' => $this->t('calendarTodoDoesntExists')
            ]);
        }

        $todo->setDone($todo->getDone() ? 0 : 1);

        $this->repo('Todo')->save($todo);

        return $this->responseAJAX([
            'status' => 'success',
            'message' => $this->t('calendarTodoUpdated')
        ]);
    }

    public function saveWidgetNoteAction($request)
    {
        $this->openSettings('user')->set('mod.calendar.widget.notes', $request->get('note'));

        return $this->responseAJAX([
            'status' => 'success',
            'message' => $this->t('calendarNoteUpdated')
        ]);
    }
}
