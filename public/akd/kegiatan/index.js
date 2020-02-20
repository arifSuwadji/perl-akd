$(document).ready(function(){
	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var dari = $(".x_panel").find(".x_content #dari_tanggal").val();
		var sampai = $(".x_panel").find(".x_content #sampai_tanggal").val();
		var bidang = $(".x_panel").find(".x_content #bidang").val();
		var kategori = $(".x_panel").find(".x_content #kategori").val();
		var kegiatan = $(".x_panel").find(".x_content #kegiatan").val();
		var dpd = $(".x_panel").find(".x_content #dpd").val();
		var kecamatan = $(".x_panel").find(".x_content #kecamatan").val();
		var kelurahan = $(".x_panel").find(".x_content #kelurahan").val();
		var rw = $(".x_panel").find(".x_content #rw").val();
		$(location).attr("href","?dmy1="+dari+"&dmy2="+sampai+"&bidang="+bidang+"&kategori="+kategori+"&kegiatan="+kegiatan+"&dpd="+dpd+"&kecamatan="+kecamatan+"&kelurahan="+kelurahan+"&rw="+rw);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_kegiatan").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_kegiatan").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #entri_kegiatan").on("click", function(){
		$(location).attr("href","/kegiatan/entri_kegiatan");
	});

	$(".x_panel").find(".x_title #edit_kegiatan").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kegiatan").each(function(){
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
			$(".peringatan").find("#keterangan").text("kegiatan belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu kegiatan.");
		}else{
			$(location).attr("href","/kegiatan/edit_kegiatan?id="+id);
		}
	});

	$(".x_panel").find(".x_title #detail_kegiatan").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kegiatan").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				id = self.val();
				i++;
			}
		});
		if(i == 0){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Detail");
			$(".peringatan").find("#icon").addClass("fa-info");
			$(".peringatan").find("#keterangan").text("kegiatan belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Detail");
			$(".peringatan").find("#icon").addClass("fa-info");
			$(".peringatan").find("#keterangan").text("Pilih satu kegiatan.");
		}else{
			$(location).attr("href","/kegiatan/detail_kegiatan?id="+id);
		}
	});

	$(".x_panel").find(".x_title #nilai_kegiatan").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kegiatan").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				id = self.val();
				i++;
			}
		});
		if(i == 0){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Penilaian");
			$(".peringatan").find("#icon").addClass("fa-calculator");
			$(".peringatan").find("#keterangan").text("kegiatan belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Penilaian");
			$(".peringatan").find("#icon").addClass("fa-calculator");
			$(".peringatan").find("#keterangan").text("Pilih satu kegiatan.");
		}else{
			$(location).attr("href","/kegiatan/nilai_kegiatan?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_kegiatan").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_kegiatan").each(function(){
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
			$(".peringatan").find("#keterangan").text("Kegiatan belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-kegiatan").data('id', id).data('name',name).modal('show');
			$(".modal-kegiatan").on("shown.bs.modal", function(){
				$(".modal-kegiatan").find(".modal-footer #id").data('id',id);
				$(".modal-kegiatan").find(".modal-body #keterangan").remove();
				$(".modal-kegiatan").find(".modal-body #konfirmasi").remove();
				$(".modal-kegiatan").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-kegiatan").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-kegiatan").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-kegiatan").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-kegiatan").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-kegiatan").data('id');
		var name = $(".modal-kegiatan").data('name');
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
		$.post("/kegiatan/index", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus kegiatan gagal.");
		});
	});
});
