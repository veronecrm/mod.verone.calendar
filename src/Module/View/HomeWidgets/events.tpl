@no-extends
<div class="widget-head">
    <div class="buttons-group">
        <a href="{{ createUrl('Calendar', 'Calendar') }}" class="btn"><i class="fa fa-calendar"></i></a>
        <button class="btn widget-options" type="button"><i class="fa fa-cog"></i></button>
    </div>
    <h2>{{ t('calendarQuickViewModalTitle') }} (<?=count($events)?>)</h2>
</div>
<div class="widget-body">
    <div class="calendar-events-list">
        @render('eventsList.Parts.Calendar', [ 'events' => $events ])
    </div>
    <a href="{{ createUrl('Calendar', 'Calendar') }}" class="btn btn-block"><i class="fa fa-calendar"></i> {{ t('calendarGoToCalendar') }}</a>
    <div style="height:12px"></div>
</div>
<style>
    #widget-calendar-calendar .calendar-events-list > div {padding:10px 0;}
    #widget-calendar-calendar .calendar-events-list .info {left:0;}
    #widget-calendar-calendar .calendar-events-list > div:first-child {border-top:none;padding-top:0;}
    #widget-calendar-calendar .calendar-events-list > div:first-child .info {top:0;}
</style>
