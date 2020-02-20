$(document).ready(function(){
	$('#upload_kecamatanKelurahan').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$('.x_panel').find('.x_content #dpd').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$(".x_panel").find(".x_content #upload_kecamatan").on("click", function(){
		var dpd = $(".x_panel").find(".x_content #dpd").val();
		var data_upload = $(".x_panel").find(".x_content #data_upload").val();
		if(!dpd){
			$(".peringatan").find("#keterangan").text("dpd belum dipilih.");
			$('.info').addClass('hidden');
			$('.peringatan').removeClass('hidden');
		}else if(!data_upload){
			$(".x_content").find("#data_upload").prop('required', true);
			$(".peringatan").find("#keterangan").text("tidak ada file yang diupload.");
			$('.info').addClass('hidden');
			$(".x_panel").find("#upload_kecamatanKelurahan").submit();
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("upload");
			$(".x_panel").find("#upload_kecamatanKelurahan").append($(op));
			$(".x_panel").find("#upload_kecamatanKelurahan").submit();
		}
	});
});
