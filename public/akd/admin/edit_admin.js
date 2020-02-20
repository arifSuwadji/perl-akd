$(document).ready(function(){
	$(".x_panel").find(".x_content #admin_grup").select2({ allowClear : true});

	$(".x_panel").find(".x_content #status").select2({ allowClear : true});

	$(".x_panel").find(".x_content #unlock_password").on("click", function(){
		$(".x_panel").find(".x_content #hide_unlock").addClass('collapse');
		$(".x_panel").find(".x_content #new_password").removeClass('collapse');
		$(".x_panel").find(".x_content #password").focus();
	});

	$('#edit_admin').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_admin").on("click", function(){
		var data_id = $(this).data('id');
		var admin = $(".x_panel").find(".x_content #admin").val();
		var password = $(".x_panel").find(".x_content #password").val();
		var nama_lengkap = $(".x_panel").find(".x_content #nama_lengkap").val();
		var admin_grup = $(".x_panel").find(".x_content #admin_grup").val();
		if(!admin){
			$(".x_content").find("#admin").prop('required', true);
			$(".peringatan").find("#keterangan").text("admin belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#edit_admin").submit();
		}else if(data_id == 0){
			if(!password){
				$(".x_content").find("#password").prop('required', true);
				$(".peringatan").find("#keterangan").text("password belum diisi.");
				$('.info').toggleClass('hidden');
				$(".x_panel").find("#edit_admin").submit();
			}
		}else if(!nama_lengkap){
			$(".x_content").find("#nama_lengkap").prop('required', true);
			$(".peringatan").find("#keterangan").text("nama lengkap belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#edit_admin").submit();
		}else if(!admin_grup){
			$(".x_content").find("#admin_grup").prop('required', true);
			$(".peringatan").find("#keterangan").text("admin grup belum dipilih.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#edit_admin").submit();
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("edit");
			$(".x_panel").find("#edit_admin").append($(op));
			$(".x_panel").find("#edit_admin").submit();
		}
	});
});
