<#include "macro-head.ftl">
<!DOCTYPE html>
<html>
<head>
<@head title="${appTitle}">
<meta name="keywords" content="${metaKeywords}"/>
<meta name="description" content=""/>
</@head>
</head>
<body>
<div class="container body-container">
	<#include "admin/header.ftl">
	<div class="row">
		<div class="span3">
			<#include "admin/side.ftl">
		</div>
		<div class="span9">
			<h4>导航发布</h4>
			<div class="succ-toggle">
				<form id="nav-form" action='${contextPath}/admin/navs<#if (nav.id)??>/${nav.id}</#if>.json' method="post">
					<div class="control-group">
					<label class="control-label" for="name">导航名称</label>
					<input type="text" name="name" placeholder="友链名称" value='${(nav.name)!}' class="span9">
					<span id="msg-name" class="help-block"></span>
					</div>
					<div class="control-group">
					<label class="control-label" for="url">导航URL</label>
					<input type="text" name="url" placeholder="访问地址" value="${(nav.url)!}" class="span9" />
					<span id="msg-url" class="help-block"></span>
					</div>
					<div class="control-group">
					<label class="control-label" for="rank">排序 <small> (数字，越小越靠前)</small></label>
					<input type="text" name="rank" value="${(nav.rank)!'0'}" class="span9" />
					<span id="msg-rank" class="help-block"></span>
					</div>
					<button type="submit" class="btn btn-primary">发布</button>
					<div id="msg-submit" class="alert alert-info line-alert help-inline" style="display: none;">
				    </div>
				</form>
			</div>
			<div class="succ-toggle" style="display: none;">
			<h1>更新成功</h1>
			<p>
			<a href="${contextPath}/admin/navs/p/1">查看</a>
			<a href="${contextPath}/admin/navs/create">继续添加</a>
			<a id="edit_nav">继续编辑</a>
			</p>
			</div>
		</div>
	</div>
	<#include "admin/footer.ftl">
</div>
<script type="text/javascript" src="${contextPath}/js/form/jquery.form.js"></script>
<script type="text/javascript">
$("#nav-nav-new").addClass("active");
$('#nav-form').ajaxForm({
	dataType:"json",
	beforeSerialize:function($form, options) {
	},
	beforeSubmit:function(formData, jqForm, options) {
	},
	success:function(data) {
		if (data && data.fieldErrorList) {
			$(".control-group").removeClass("error");
			for ( var i = 0; i < data.fieldErrorList.length; i++) {
				var error = data.fieldErrorList[i];
				$('[name="'+error.field+'"]')
					.tooltip({title:error.defaultMessage,placement:"left"})
					.tooltip('show')
					.keypress(function(){
						$(this).tooltip("destroy").unbind();
						$(this).parent().removeClass("error");
					})
					.parent().addClass("error");
			}
		} else if (data) {
			if (data.result) {
				$("#msg-submit").html("更新成功").show();
				$("#edit_nav").attr("href", "${contextPath}/admin/navs/"+data.data+"/edit");
				$(".succ-toggle").toggle();
			} else {
				$("#msg-submit").html(data.message).show();
			}
		}
	},
	error:function(jqXHR, textStatus, errorThrown) {
		$("#msg-submit").html(textStatus+jqXHR.responseText).show();
	}
});
</script>
</body>
</html>