$(document).ready(function(){
	$('.x_panel').find('.x_content .status').select2({ allowClear: true });

	$('.x_panel').find('.x_content .admin_grup').select2({allowClear:true});

	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama = $(".x_panel").find(".x_content #nama").val();
		$(location).attr("href","?nama="+nama);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_grup").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_grup").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_admin_grup").on("click", function(){
		$(location).attr("href","/admin/tambah_admin_grup");
	});

	$(".x_panel").find(".x_title #edit_admin_grup").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_grup").each(function(){
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
			$(".peringatan").find("#keterangan").text("Admin grup belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu admin grup.");
		}else{
			$(location).attr("href","/admin/edit_admin_grup?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_admin_grup").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_grup").each(function(){
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
			$(".peringatan").find("#keterangan").text("Admin grup belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-grup").data('id', id).data('name',name).modal('show');
			$(".modal-grup").on("shown.bs.modal", function(){
				$(".modal-grup").find(".modal-footer #id").data('id',id);
				$(".modal-grup").find(".modal-body #keterangan").remove();
				$(".modal-grup").find(".modal-body #konfirmasi").remove();
				$(".modal-grup").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-grup").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-grup").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-grup").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-grup").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-grup").data('id');
		var name = $(".modal-grup").data('name');
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
		$.post("/admin/admin_grup", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus admin gagal.");
		});
	});
});
