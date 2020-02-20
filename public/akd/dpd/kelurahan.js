$(document).ready(function(){
	$('.x_panel').find('.x_content .kecamatan').select2({ allowClear: true});

	$('.x_panel').find('.x_content .dpd').select2({ allowClear: true});

	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		var kecamatan = $(".x_panel").find(".x_content .kecamatan").val();
		var dpd = $(".x_panel").find(".x_content .dpd").val();
		$(location).attr("href","?nama="+nama+"&kecamatan="+kecamatan+"&dpd="+dpd);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_kelurahan").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_kelurahan").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_kelurahan").on("click", function(){
		$(location).attr("href","/dpd/tambah_kelurahan");
	});

	$(".x_panel").find(".x_title #edit_kelurahan").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kelurahan").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				id = self.val();
				i++;
			}
		});
		if(i == 0){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Kelurahan belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu kelurahan.");
		}else{
			$(location).attr("href","/dpd/edit_kelurahan?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_kelurahan").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kelurahan").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				id += self.val()+"_";
				name += self.data('name')+"_";
				i++;
			}
		});
		if(i == 0){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Hapus");
			$(".peringatan").find("#icon").addClass("fa-times");
			$(".peringatan").find("#keterangan").text("Kelurahan belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-kelurahan").data('id', id).data('name',name).modal('show');
			$(".modal-kelurahan").on("shown.bs.modal", function(){
				$(".modal-kelurahan").find(".modal-footer #id").data('id',id);
				$(".modal-kelurahan").find(".modal-body #keterangan").remove();
				$(".modal-kelurahan").find(".modal-body #konfirmasi").remove();
				$(".modal-kelurahan").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-kelurahan").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-kelurahan").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-kelurahan").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-kelurahan").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-kelurahan").data('id');
		var name = $(".modal-kelurahan").data('name');
		var arrayName = name.split('_');
		var info = "";
		$.each(arrayName, function(index,value){
			if(index < (arrayName.length-1)){
				info += value+", ";
			}else{
				info += value;
			}
		});
		var op = 'hapus';
		$.post("/dpd/kelurahan", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus kelurahan gagal.");
		});
	});
});
