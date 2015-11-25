<?php $app->assetter()->load('jquery-ui'); ?>

<div class="page-header">
    <div class="page-header-content">
        <div class="page-title">
            <h1>
                <i class="fa fa-check-square-o"></i>
                {{ t('calendarTodos') }}
            </h1>
        </div>
        <div class="heading-elements">
            <div class="heading-btn-group">
                <a href="{{ createUrl('Calendar', 'Todo', 'add') }}" class="btn btn-icon-block btn-link-success">
                    <i class="fa fa-plus"></i>
                    <span>{{ t('calendarTodoNew') }}</span>
                </a>
            </div>
        </div>
        <div class="heading-elements-toggle">
            <i class="fa fa-ellipsis-h"></i>
        </div>
    </div>
    <div class="breadcrumb-line">
        <ul class="breadcrumb">
            <li><a href="{{ createUrl() }}"><i class="fa fa-home"> </i>Verone</a></li>
            <li class="active"><a href="{{ createUrl('Calendar', 'Todo', 'index') }}">{{ t('calendarTodos') }}</a></li>
        </ul>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <table class="table table-default table-clicked-rows table-responsive" id="mod-calendar-todos-list">
                <thead>
                    <tr>
                        <th class="text-center span-1">&nbsp;</th>
                        <th class="span-2">&nbsp;</th>
                        <th>{{ t('calendarTodo') }}</th>
                        <th>{{ t('from') }}</th>
                        <th>{{ t('for') }}</th>
                        <th class="text-right">{{ t('action') }}</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach($elements as $item): ?>
                        <?php $item = $app->repo('Todo', 'Calendar')->collectDetails($item); ?>
                        <tr id="linr_{{ $item->getId() }}" data-row-click-target="<?php echo $app->createUrl('Calendar', 'Todo', 'edit', [ 'id' => $item->getId() ]); ?>" class="<?php echo ($item->getDone() ? 'done' : ''); ?>">
                            <td class="text-center hidden-xs"><input type="checkbox" name="todo_check" value="<?php echo $item->getId(); ?>"<?php echo ($item->getDone() ? ' checked="checked"' : ''); ?> /></td>
                            <td data-th="{{ t('calendarTodoPriority') }}" class="span-2"><span class="label label-<?php echo $item->getPriorityClassName(); ?>">{{ t('calendarPriority'.$item->getPriority()) }}</span></td>
                            <td data-th="{{ t('calendarTodo') }}" class="mod-todo-text"><?php echo $item->getDescription(); ?></td>
                            <td data-th="{{ t('from') }}" class="mod-todo-text"><?php echo (is_object($item->getUserFrom()) && $item->getUserFrom()->getId() == $app->user()->getId()) ? $app->t('calendarTodoUserForMe') : $item->getUserFrom()->getName(); ?></td>
                            <td data-th="{{ t('for') }}" class="mod-todo-text"><?php echo (is_object($item->getUserFor()) && $item->getUserFor()->getId() == $app->user()->getId()) ? $app->t('calendarTodoUserForMe') : $item->getUserFor()->getName(); ?></td>
                            <td data-th="{{ t('action') }}" class="app-click-prevent">
                                <div class="actions-box">
                                    <div class="btn-group right">
                                        <a href="<?php echo $app->createUrl('Calendar', 'Todo', 'edit', [ 'id' => $item->getId() ]); ?>" class="btn btn-default btn-xs btn-main-action" title="{{ t('edit') }}"><i class="fa fa-pencil"></i></a>
                                        <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" >
                                            <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu with-headline right">
                                            <li class="headline">{{ t('moreOptions') }}</li>
                                            <li><a href="<?php echo $app->createUrl('Calendar', 'Todo', 'edit', [ 'id' => $item->getId() ]); ?>" title="{{ t('edit') }}"><i class="fa fa-pencil"></i> {{ t('edit') }}</a></li>
                                            <li role="separator" class="divider"></li>
                                            <li class="item-danger"><a href="#" data-toggle="modal" data-target="#todo-delete" data-href="<?php echo $app->createUrl('Calendar', 'Todo', 'delete', [ 'id' => $item->getId() ]); ?>" title="{{ t('delete') }}"><i class="fa fa-remove danger"></i> {{ t('delete') }}</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="todo-delete" tabindex="-1" role="dialog" aria-labelledby="todo-delete-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content modal-danger">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="{{ t('close') }}"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="todo-delete-modal-label">{{ t('calendarTodoDeleteConfirmationHeader') }}</h4>
            </div>
            <div class="modal-body">
                {{ t('calendarTodoDeleteConfirmationContent') }}
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
                <a href="#" class="btn btn-danger">{{ t('syes') }}</a>
            </div>
        </div>
    </div>
</div>

<style>
    .table tr.done td {background-color:#F0F0F0;opacity:.3;}
    .table tr.done:hover td {opacity:1;}
    .table tr.done .mod-todo-text {text-decoration:line-through;}
</style>

<script>
    $('#todo-delete').on('show.bs.modal', function (event) {
        $(this).find('.modal-footer a').attr('href', $(event.relatedTarget).attr('data-href'));
    });
    $('table.table tbody input').change(function() {
        APP.CalendarQuickView.Todos.events.toggleDone($(this).val(), $(this).parent().parent());
        $(this).parent().parent().toggleClass('done');
    });
    $(function() {
        $('#mod-calendar-todos-list tbody').sortable({
            helper: function(e, ui) {
                ui.children().each(function() {
                    $(this).width($(this).width());
                });
                return ui;
            },
            update: function(event, ui)
            {
                $.ajax({
                    type     : "GET",
                    url      : "<?php echo $app->createUrl('Calendar', 'Todo', 'sortable'); ?>&" + $('#mod-calendar-todos-list tbody').sortable('serialize'),
                    success : function(msg) {
                        if(msg == 'OK')
                        {
                            APP.FluidNotification.open('{{ t('calendarTodoOrderingChanged') }}', { theme: 'success' });
                        }
                        else
                        {
                            APP.FluidNotification.open('{{ t('calendarTodoOrderingChangError') }}', { theme: 'error' });
                        }
                    },
                    error:    function(error) {
                        APP.FluidNotification.open('{{ t('calendarTodoOrderingChangError') }}', { theme: 'error' });
                        console.log(error);
                    }
                });
            }
        }).disableSelection();
    });
</script>
