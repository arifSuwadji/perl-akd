$(document).ready(function(){

	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		$(location).attr("href","?nama="+nama);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_kategori").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_kategori").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_kategori").on("click", function(){
		$(location).attr("href","/kategori/tambah_kategori");
	});

	$(".x_panel").find(".x_title #edit_kategori").on("click", function(){
		var id = "";
		var idsub = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kategori").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				id = self.val();
				idsub = self.data('idsub');
				i++;
			}
		});
		if(i == 0){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Kategori/Sub kategori belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu kategori/sub kategori.");
		}else{
			$(location).attr("href","/kategori/edit_kategori?id="+id+"&id_sub="+idsub);
		}
	});

	$(".x_panel").find(".x_title #hapus_kategori").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kategori").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				if(self.data('idsub')){
					id += self.data('idsub')+"_";
				}else{
					id += self.val()+"_";
				}
				name += self.data('name')+"_";
				i++;
			}
		});
		if(i == 0){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Hapus");
			$(".peringatan").find("#icon").addClass("fa-times");
			$(".peringatan").find("#keterangan").text("Kategori belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-kategori").data('id', id).data('name',name).modal('show');
			$(".modal-kategori").on("shown.bs.modal", function(){
				$(".modal-kategori").find(".modal-footer #id").data('id',id);
				$(".modal-kategori").find(".modal-body #keterangan").remove();
				$(".modal-kategori").find(".modal-body #konfirmasi").remove();
				$(".modal-kategori").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-kategori").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-kategori").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-kategori").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-kategori").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-kategori").data('id');
		var name = $(".modal-kategori").data('name');
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
		$.post("/kategori/index", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus kategori gagal.");
		});
	});
});
