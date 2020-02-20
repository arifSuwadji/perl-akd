$(document).ready(function(){
	setTimeout(function(){
		$('.x_panel').find('#sub_kategori').addClass('collapse');
	},10);

	$('.x_panel').find('.x_content .induk').select2({ allowClear: true});

	$('.x_panel').find('.x_content .induk').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('.x_panel').find('.x_content #show_sub').on("ifChecked", function(){
		$('.x_panel').find('#kategori').addClass('collapse');
		$('.x_panel').find('#sub_kategori').removeClass('collapse');
		$('.x_panel').find('.x_content #show_kategori').iCheck('uncheck');
	});

	$('.x_panel').find('.x_content #show_kategori').on("ifChecked", function(){
		$('.x_panel').find('#sub_kategori').addClass('collapse');
		$('.x_panel').find('#kategori').removeClass('collapse');
		$('.x_panel').find('.x_content #show_sub').iCheck('uncheck');
		$('.peringatan').addClass('hidden');
	});

	$('#edit_kategori').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$('#edit_subKategori').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_kategori").on("click", function(){
		var form = $(this).data('form');
		var nama = $(".x_panel").find(".x_content #nama").val();
		var tipe = '';
		if(form == 'edit_subKategori'){
			var tipe = 'sub';
		}
		var induk = $(".x_panel").find(".x_content .induk").val();
		$(".x_panel").find(".x_content #tipe").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				tipe = self.val();
			}
		});
		if(!nama){
			$(".x_content").find("#nama").prop('required', true);
			$(".peringatan").find("#keterangan").text("Nama belum diisi.");
			$('.info').toggleClass('hidden');
			$(".x_panel").find("#edit_kategori").submit();
		}else if(tipe == 'sub'){
			if(!induk){
				$(".peringatan").find("#keterangan").text("Induk kategori belum dipilih.");
				$('.info').toggleClass('hidden');
				$('.peringatan').toggleClass('hidden');
			}else{
				var op = $("<input>").attr("type", "hidden").attr("name", "op").val("edit");
				$(".x_panel").find("#edit_subKategori").append($(op));
				$(".x_panel").find("#edit_subKategori").submit();
			}
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("edit");
			$(".x_panel").find("#edit_kategori").append($(op));
			$(".x_panel").find("#edit_kategori").submit();
		}
	});
});
