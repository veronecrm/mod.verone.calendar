@no-extends
@if $events === array()
    <p class="no-events">{{ t('calendarThereIsNoEventsWeek') }}</p>
@endif
@foreach $events
    @if $app->datetime()->isToday($item['start-timestamp'])
        <?php $isToday = true; ?>
    @else
        <?php $isToday = false; ?>
    @endif
    <div id="event-{{ $item['id'] }}" <?php echo($isToday ? ' class="today"' : '') ;?>>
        <div class="info">
            <div class="calendar-day">
                @if $isToday
                    <span class="today">{{ t('today') }}</span>
                @endif
                <span class="day"><?=date('d', $item['start-timestamp'])?></span>
                <span class="month"><?=$app->localisation()->monthName(date('m', $item['start-timestamp']), 2)?></span>
            </div>
            @if date('H:i', $item['start-timestamp']) != '00:00'
                <div class="clock-hrs">
                    <span><?=date('H', $item['start-timestamp'])?></span>:<span><?=date('i', $item['start-timestamp'])?></span>
                </div>
            @endif
        </div>
        <div class="cont">
            <h4>{{ $item['title'] }}</h4>
            <span class="label" style="background-color:{{ $item['color'] }}">{{ $item['typeName'] }}</span>
            <p>{{ $item['description'] | raw }}</p>
        </div>
    </div>
@endforeach
