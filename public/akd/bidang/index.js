$(document).ready(function(){

	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		$(location).attr("href","?nama="+nama);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_bidang").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_bidang").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_bidang").on("click", function(){
		$(location).attr("href","/bidang/tambah_bidang");
	});

	$(".x_panel").find(".x_title #edit_bidang").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_bidang").each(function(){
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
			$(".peringatan").find("#keterangan").text("Bidang belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu bidang.");
		}else{
			$(location).attr("href","/bidang/edit_bidang?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_bidang").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_bidang").each(function(){
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
			$(".peringatan").find("#keterangan").text("Bidang belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-bidang").data('id', id).data('name',name).modal('show');
			$(".modal-bidang").on("shown.bs.modal", function(){
				$(".modal-bidang").find(".modal-footer #id").data('id',id);
				$(".modal-bidang").find(".modal-body #keterangan").remove();
				$(".modal-bidang").find(".modal-body #konfirmasi").remove();
				$(".modal-bidang").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-bidang").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-bidang").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-bidang").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-bidang").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-bidang").data('id');
		var name = $(".modal-bidang").data('name');
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
		$.post("/bidang/index", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus bidang gagal.");
		});
	});
});
