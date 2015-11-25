<div class="page-header">
	<div class="page-header-content">
		<div class="page-title">
			<h1>
				<i class="fa fa-check-square-o"></i>
				<?php echo $app->t($todo->getId() ? 'calendarTodoEdit' : 'calendarTodoNew'); ?>
			</h1>
		</div>
		<div class="heading-elements">
			<div class="heading-btn-group">
				<a href="#" data-form-submit="form" data-form-param="apply" class="btn btn-icon-block btn-link-success">
					<i class="fa fa-save"></i>
					<span>{{ t('apply') }}</span>
				</a>
				<a href="#" data-form-submit="form" data-form-param="save" class="btn btn-icon-block btn-link-success">
					<i class="fa fa-save"></i>
					<span>{{ t('save') }}</span>
				</a>
				<a href="#" class="btn btn-icon-block btn-link-danger app-history-back">
					<i class="fa fa-remove"></i>
					<span>{{ t('cancel') }}</span>
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
			<li><a href="{{ createUrl('Calendar', 'Todo', 'index') }}">{{ t('calendarTodos') }}</a></li>
			@if $todo->getId()
				<li class="active"><a href="{{ createUrl('Calendar', 'Todo', 'edit', [ 'id' => $todo->getId() ]) }}">{{ t('calendarTodoEdit') }}</a></li>
			@else
				<li class="active"><a href="{{ createUrl('Calendar', 'Todo', 'add') }}">{{ t('calendarTodoNew') }}</a></li>
			@endif
		</ul>
	</div>
</div>

<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<form action="<?php echo $app->createUrl('Calendar', 'Todo', $todo->getId() ? 'update' : 'save'); ?>" method="post" id="form" class="form-validation">
				<input type="hidden" name="id" value="<?php echo $todo->getId(); ?>" />
				<div class="row">
					<div class="col-md-6">
						<div class="panel panel-default">
							<div class="panel-heading"><?php echo $app->t('basicInformations'); ?></div>
							<div class="panel-body">
								<div class="form-group">
									<label for="description" class="control-label"><?=$app->t('calendarTodo')?></label>
									<textarea class="form-control auto-grow required" id="description" name="description" autofocus=""><?=$todo->getDescription()?></textarea>
								</div>
								<div class="form-group">
									<label for="priority" class="control-label"><?=$app->t('calendarTodoPriority')?></label>
									<select class="form-control" id="priority" name="priority">
										<option value="0"<?php echo $todo->getPriority() == 0 ? ' selected="selected"' : ''; ?>><?=$app->t('calendarPriority0')?></option>
										<option value="1"<?php echo $todo->getPriority() == 1 ? ' selected="selected"' : ''; ?>><?=$app->t('calendarPriority1')?></option>
										<option value="2"<?php echo $todo->getPriority() == 2 ? ' selected="selected"' : ''; ?>><?=$app->t('calendarPriority2')?></option>
										<option value="3"<?php echo $todo->getPriority() == 3 ? ' selected="selected"' : ''; ?>><?=$app->t('calendarPriority3')?></option>
									</select>
								</div>
								<div class="form-group">
									<label for="type" class="control-label"><?=$app->t('calendarTodoType')?></label>
									<select class="form-control" id="type" name="type">
										<option value="0"<?php echo $todo->getType() == 0 ? ' selected="selected"' : ''; ?>><?=$app->t('calendarTodoType0')?></option>
										<option value="1"<?php echo $todo->getType() == 1 ? ' selected="selected"' : ''; ?>><?=$app->t('calendarTodoType1')?></option>
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="panel panel-default">
							<div class="panel-heading"><?php echo $app->t('additionallyInformations'); ?></div>
							<div class="panel-body">
								<div class="form-group">
									<label for="userFor" class="control-label"><?=$app->t('calendarTodoUserFor')?></label>
									<select class="form-control" id="userFor" name="userFor">
										<?php foreach($users as $user): ?>
											<option value="<?=$user->getId()?>"<?php echo ($user->getId() == $app->user()->getId() ? ' selected="selected"' : ''); ?>><?php echo ($user->getId() == $app->user()->getId() ? $app->t('calendarTodoUserForMe') : $user->getName()); ?></option>
										<?php endforeach; ?>
									</select>
								</div>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
