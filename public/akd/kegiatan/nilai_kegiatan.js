$(document).ready(function(){
	$('.x_panel').find('.x_content .tipe').select2({ allowClear: true});

	$('.x_panel').find('.x_content .tipe').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('#nilai_kegiatan').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_nilai").on("click", function(){
		var tipe = $(".x_panel").find(".x_content .tipe").val();
		var skor = $(".x_panel").find(".x_content #skor").val();
		if(!tipe){
			$(".peringatan").find("#keterangan").text("tipe belum dipilih.");
			$('.info').toggleClass('hidden');
			$('.peringatan').toggleClass('hidden');
		}else if(!skor){
			$(".x_content").find("#skor").prop('required', true);
			$(".peringatan").find("#keterangan").text("skor belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#nilai_kegiatan").submit();
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("nilai");
			$(".x_panel").find("#nilai_kegiatan").append($(op));
			$(".x_panel").find("#nilai_kegiatan").submit();
		}
	});
});
