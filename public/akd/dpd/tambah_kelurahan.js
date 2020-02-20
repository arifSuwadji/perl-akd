$(document).ready(function(){
	$('.x_panel').find('.x_content .kecamatan').select2({ allowClear: true});

	$('.x_panel').find('.x_content .kecamatan').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('#tambah_kelurahan').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_kelurahan").on("click", function(){
		var kode = $(".x_panel").find(".x_content #kode").val();
		var nama = $(".x_panel").find(".x_content #nama").val();
		var kecamatan = $(".x_panel").find(".x_content .kecamatan").val();
		if(!kode){
			$(".x_content").find("#kode").prop('required', true);
			$(".peringatan").find("#keterangan").text("kode belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#tambah_kelurahan").submit();
		}else if(!nama){
			$(".x_content").find("#nama").prop('required', true);
			$(".peringatan").find("#keterangan").text("nama belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#tambah_kelurahan").submit();
		}else if(!kecamatan){
			$(".peringatan").find("#keterangan").text("kecamatan belum dipilih.");
			$('.info').toggleClass('hidden');
			$('.peringatan').toggleClass('hidden');
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("tambah");
			$(".x_panel").find("#tambah_kelurahan").append($(op));
			$(".x_panel").find("#tambah_kelurahan").submit();
		}
	});
});
