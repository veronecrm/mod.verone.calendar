@no-extends
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="{{ t('close') }}"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title" id="mod-calendar-quickview-modal-label">{{ t('calendarQuickViewModalTitle') }}</h4>
        </div>
        <div class="modal-body">
            <div role="tabpanel">
                <ul class="nav nav-tabs" role="tablist">
                    <li role="presentation"><a href="#mod-calendar-tab-calendar" aria-controls="mod-calendar-tab-calendar" role="tab" data-toggle="tab">{{ t('calendarCalendar') }}</a></li>
                    <li role="presentation" class="active"><a href="#mod-calendar-tab-todos" aria-controls="mod-calendar-tab-todos" role="tab" data-toggle="tab">{{ t('calendarTodos') }}</a></li>
                </ul>
                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane" id="mod-calendar-tab-calendar">
                        <div class="calendar-events-list">
                            @render('eventsList.Parts.Calendar', [ 'events' => $events ])
                        </div>
                        <div style="margin-top:10px;">
                            <a href="<?=$app->createUrl('Calendar', 'Calendar')?>" class="btn btn-default" style="float:left"><i class="fa fa-calendar"></i> {{ t('calendarCalendar') }}</a>
                            <div style="clear:both"></div>
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane active" id="mod-calendar-tab-todos">
                        @render('todoList.HomeWidgets.Calendar', [ 'todos' => $todos ])
                        <div style="margin-top:10px;">
                            <a href="<?=$app->createUrl('Calendar', 'Todo')?>" class="btn btn-default" style="float:left"><i class="fa fa-list"></i> {{ t('calendarTodos') }}</a>
                            <a href="<?=$app->createUrl('Calendar', 'Todo', 'add')?>" class="btn btn-success" style="float:right"><i class="fa fa-plus"></i> {{ t('calendarTodoNew') }}</a>
                            <div style="clear:both"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
        </div>
    </div>
</div>
