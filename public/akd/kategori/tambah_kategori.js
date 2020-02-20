$(document).ready(function(){
	setTimeout(function(){
		$('.x_panel').find('.x_content #group_induk').addClass('collapse');
	},10);

	$('.x_panel').find('.x_content .induk').select2({ allowClear: true});

	$('.x_panel').find('.x_content .induk').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('.x_panel').find('.x_content #tipe').on("ifChecked", function(){
		var self = $(this);
		if(self.val() == 'induk'){
			$('.x_panel').find('.x_content #group_induk').addClass('collapse');
		}else if(self.val() == 'sub'){
			$('.x_panel').find('.x_content #group_induk').removeClass('collapse');
		}
	});

	$('#tambah_kategori').parsley().on('field:validated', function() {
		var ok = $('.parsley-error').length === 0;
		$('.peringatan').toggleClass('hidden', ok);
	}).on('form:submit', function() {
		return true;
	});

	$(".x_panel").find(".x_content #simpan_kategori").on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		var tipe = '';
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
			$(".x_panel").find("#tambah_kategori").submit();
		}else if(tipe == 'sub'){
			if(!induk){
				$(".peringatan").find("#keterangan").text("Induk kategori belum dipilih.");
				$('.info').toggleClass('hidden');
				$('.peringatan').toggleClass('hidden');
			}else{
				var op = $("<input>").attr("type", "hidden").attr("name", "op").val("tambah");
				$(".x_panel").find("#tambah_kategori").append($(op));
				$(".x_panel").find("#tambah_kategori").submit();
			}
		}else{
			var op = $("<input>").attr("type", "hidden").attr("name", "op").val("tambah");
			$(".x_panel").find("#tambah_kategori").append($(op));
			$(".x_panel").find("#tambah_kategori").submit();
		}
	});
});
