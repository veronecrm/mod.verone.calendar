@no-extends
<div class="widget-head">
    <div class="buttons-group">
        <button class="btn btn-notes-save" type="button"><i class="fa fa-save"></i></button>
        <button class="btn widget-options" type="button"><i class="fa fa-cog"></i></button>
    </div>
    <h2>{{ t('calendarMyNotes') }}</h2>
</div>
<div class="widget-body">
    <textarea class="form-control" style="position:absolute;z-index:1;left:0px;top:0px;right:0px;bottom:0px;margin:0;height:0;max-width:100%;max-height:100%;display:block;resize:none;width:100%;height:100%;"><?php echo $app->openSettings('user')->get('mod.calendar.widget.notes'); ?></textarea>
</div>
<script>
    $(function() {
        $('#widget-calendar-notes .btn-notes-save').click(function() {
            $('#widget-calendar-notes .widget-body').append('<div class="loader loader-fit-to-container"><div class="loader-animate"></div></div>');

            APP.AJAX.call({
                url  : "{{ createUrl('Calendar', 'Todo', 'saveWidgetNote') }}",
                data : {
                    note : $('#widget-calendar-notes .widget-body textarea').val()
                },
                success : function(msg) {
                    $('#widget-calendar-notes .widget-body .loader').fadeTo(100, 0, function() {
                        $(this).remove();
                    });
                },
                error: function(error) {
                    $('#widget-calendar-notes .widget-body .loader').fadeTo(100, 0, function() {
                        $(this).remove();
                    });
                }
            })
        });
    })
</script>
