@no-extends
<div class="todo-list">
    <?php foreach($todos as $todo): ?>
        <div class="item<?php echo ($todo->getDone() ? ' done' : ''); ?>" data-id="<?php echo $todo->getId(); ?>">
            <div class="left-column">
                <input type="checkbox" name="todo_check" value="<?php echo $todo->getId(); ?>"<?php echo ($todo->getDone() ? ' checked="checked"' : ''); ?> />
            </div>
            <div class="right-column">
                <a href="#" class="fa fa-remove"></a>
                <span class="label label-<?php echo $todo->getPriorityClassName(); ?>"><?php echo $app->t('calendarPriority'.$todo->getPriority()); ?></span>
                <span class="desc"><?php echo $todo->getDescription(); ?></span>
                <div class="foot"><?php echo $app->datetime($todo->getDate()); ?><?php echo (is_object($todo->getUserFrom()) && $todo->getUserFrom()->getId() != $app->user()->getId() ? ' | <b>Od: '.$todo->getUserFrom()->getName().'</b>' : ''); ?></div>
            </div>
        </div>
    <?php endforeach; ?>
</div>
