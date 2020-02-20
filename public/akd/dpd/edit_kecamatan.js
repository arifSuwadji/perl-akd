$(document).ready(function(){
	$('.x_panel').find('.x_content .dpd').select2({ allowClear: true});

	$('.x_panel').find('.x_content .dpd').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('#edit_kecamatan').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_kecamatan").on("click", function(){
		var kode = $(".x_panel").find(".x_content #kode").val();
		var nama = $(".x_panel").find(".x_content #nama").val();
		var dpd = $(".x_panel").find(".x_content .dpd").val();
		if(!kode){
			$(".x_content").find("#kode").prop('required', true);
			$(".peringatan").find("#keterangan").text("kode belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#edit_kecamatan").submit();
		}else if(!nama){
			$(".x_content").find("#nama").prop('required', true);
			$(".peringatan").find("#keterangan").text("nama belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#edit_kecamatan").submit();
		}else if(!dpd){
			$(".peringatan").find("#keterangan").text("dpd belum dipilih.");
			$('.info').toggleClass('hidden');
			$('.peringatan').toggleClass('hidden');
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("edit");
			$(".x_panel").find("#edit_kecamatan").append($(op));
			$(".x_panel").find("#edit_kecamatan").submit();
		}
	});
});
