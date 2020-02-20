$(document).ready(function(){
	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		$(location).attr("href","?nama="+nama);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_dpd").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_dpd").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_dpd").on("click", function(){
		$(location).attr("href","/dpd/tambah_dpd");
	});

	$(".x_panel").find(".x_title #edit_dpd").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_dpd").each(function(){
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
			$(".peringatan").find("#keterangan").text("dpd belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu dpd.");
		}else{
			$(location).attr("href","/dpd/edit_dpd?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_dpd").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_dpd").each(function(){
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
			$(".peringatan").find("#keterangan").text("Dpd belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-dpd").data('id', id).data('name',name).modal('show');
			$(".modal-dpd").on("shown.bs.modal", function(){
				$(".modal-dpd").find(".modal-footer #id").data('id',id);
				$(".modal-dpd").find(".modal-body #keterangan").remove();
				$(".modal-dpd").find(".modal-body #konfirmasi").remove();
				$(".modal-dpd").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-dpd").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-dpd").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-dpd").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-dpd").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-dpd").data('id');
		var name = $(".modal-dpd").data('name');
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
		$.post("/dpd/index", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus dpd gagal.");
		});
	});
});
