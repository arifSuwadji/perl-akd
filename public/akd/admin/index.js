$(document).ready(function(){
	$('.x_panel').find('.x_content .status').select2({ allowClear: true });

	$('.x_panel').find('.x_content .admin_grup').select2({allowClear:true});

	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var nama_lengkap = $(".x_panel").find(".x_content #nama_lengkap").val();
		var status_admin = $('.x_panel').find('.x_content .status').val();
		var admin_grup =  $('.x_panel').find('.x_content .admin_grup').val();
		$(location).attr("href","?nama_lengkap="+nama_lengkap+"&status="+status_admin+"&admin_grup="+admin_grup);
	});

	$(".x_panel").find('.x_content #checkAll').on("ifChecked", function(){
		$(".x_panel").find(".x_content #data_admin").iCheck('check');
	});

	$(".x_panel").find('.x_content #checkAll').on("ifUnchecked", function(){
		$(".x_panel").find(".x_content #data_admin").iCheck('uncheck');
	});

	$(".x_panel").find(".x_title #tambah_admin").on("click", function(){
		$(location).attr("href","/admin/tambah_admin");
	});

	$(".x_panel").find(".x_title #edit_admin").on("click", function(){
		var id = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_admin").each(function(){
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
			$(".peringatan").find("#keterangan").text("Admin belum dipilih.");
		}else if(i >= 2){
			$(".info").addClass('hidden');
			$(".peringatan").removeClass('hidden');
			$(".peringatan").find("#judul").text("Edit");
			$(".peringatan").find("#icon").addClass("fa-edit");
			$(".peringatan").find("#keterangan").text("Pilih satu admin.");
		}else{
			$(location).attr("href","/admin/edit_admin?id="+id);
		}
	});

	$(".x_panel").find(".x_title #hapus_admin").on("click", function(){
		var id = "";
		var name = "";
		var i = 0;
		$(".x_panel").find(".x_content #data_admin").each(function(){
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
			$(".peringatan").find("#keterangan").text("Admin belum dipilih.");
		}else{
			name = name.substring(0, (name.length-1));
			var arrayName = name.split('_');
			$(".info").addClass('hidden');
			$(".peringatan").addClass('hidden');
			id = id.substring(0, (id.length-1));
			$(".modal-admin").data('id', id).data('name',name).modal('show');
			$(".modal-admin").on("shown.bs.modal", function(){
				$(".modal-admin").find(".modal-footer #id").data('id',id);
				$(".modal-admin").find(".modal-body #keterangan").remove();
				$(".modal-admin").find(".modal-body #konfirmasi").remove();
				$(".modal-admin").find(".modal-body").append('<strong id="keterangan" class="text-center"></strong>');
				$(".modal-admin").find(".modal-body").append('<strong id="konfirmasi">akan dihapus ? </strong>');
				$.each(arrayName, function(index, value){
					if(index < (arrayName.length-1)){
						$(".modal-admin").find(".modal-body #keterangan").append(value+', ');
					}else{
						$(".modal-admin").find(".modal-body #keterangan").append(value+' ');
					}
				});
			});
		}
	});

	$(".modal-admin").find(".modal-footer #ya").on("click", function(){
		var id = $(".modal-admin").data('id');
		var name = $(".modal-admin").data('name');
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
		$.post("/admin/index", {id, op}, function(data,status){
			$(location).attr("href","?info="+info+" telah dihapus.");
		}).fail(function(){
			$(location).attr("href","?info=hapus admin gagal.");
		});
	});
});
