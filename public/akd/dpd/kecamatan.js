$(document).ready(function(){
	$('.x_panel').find('.x_content .dpd').select2({ allowClear: true});

	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		var dpd = $(".x_panel").find(".x_content .dpd").val();
		$(location).attr("href","?nama="+nama+"&dpd="+dpd);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_kecamatan").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_kecamatan").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_kecamatan").on("click", function(){
		$(location).attr("href","/dpd/tambah_kecamatan");
	});

	$(".x_panel").find(".x_title #edit_kecamatan").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kecamatan").each(function(){
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
			$(".peringatan").find("#keterangan").text("kecamatan belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu kecamatan.");
		}else{
			$(location).attr("href","/dpd/edit_kecamatan?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_kecamatan").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kecamatan").each(function(){
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
			$(".peringatan").find("#keterangan").text("Kecamatan belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-kecamatan").data('id', id).data('name',name).modal('show');
			$(".modal-kecamatan").on("shown.bs.modal", function(){
				$(".modal-kecamatan").find(".modal-footer #id").data('id',id);
				$(".modal-kecamatan").find(".modal-body #keterangan").remove();
				$(".modal-kecamatan").find(".modal-body #konfirmasi").remove();
				$(".modal-kecamatan").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-kecamatan").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-kecamatan").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-kecamatan").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-kecamatan").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-kecamatan").data('id');
		var name = $(".modal-kecamatan").data('name');
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
		$.post("/dpd/kecamatan", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus kecamatan gagal.");
		});
	});
});
