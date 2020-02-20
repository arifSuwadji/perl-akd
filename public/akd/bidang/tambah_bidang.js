$(document).ready(function(){
	$('#tambah_bidang').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_bidang").on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		if(!nama){
			$(".x_content").find("#nama").prop('required', true);
			$(".peringatan").find("#keterangan").text("Nama belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#tambah_bidang").submit();
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("tambah");
			$(".x_panel").find("#tambah_bidang").append($(op));
			$(".x_panel").find("#tambah_bidang").submit();
		}
	});
});
