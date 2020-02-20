$(document).ready(function(){
	$('#tambah_admin_grup').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_grup").on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		if(!nama){
			$(".x_content").find("#nama").prop('required', true);
			$(".peringatan").find("#keterangan").text("nama belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#tambah_admin_grup").submit();
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("tambah");
			$(".x_panel").find("#tambah_admin_grup").append($(op));
			$(".x_panel").find("#tambah_admin_grup").submit();
		}
	});
});
