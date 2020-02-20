$(document).ready(function(){
	$(".x_panel").find(".x_content .admin_grup").select2({ allowClear: true});

	$(".x_panel").find(".x_content .admin_grup").on("change", function(){
		var self = $(this); 
		$(location).attr("href","?admin_grup="+self.val());
	});

	$(".x_panel").find(".x_content #cek").on("click", function(){
		$(".x_panel").find(".x_content #cek_halaman").iCheck('check');
	});

	$(".x_panel").find(".x_content #batal").on("click", function(){
		$(".x_panel").find(".x_content #cek_halaman").iCheck('uncheck');
	});

	$('#hak_akses').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #perbarui").on("click", function(){
		var grup =  $(".x_panel").find(".x_content .admin_grup").val();
		if(!grup){
			$(".x_content").find(".admin_grup").prop('required', true);
			$(".peringatan").find("#keterangan").text("Admin grup belum dipilih.");
			$('.info').toggleClass('hidden');
			$("#hak_akses").submit();
		}else{
			$("#hak_akses").submit();
		}
	});
});
