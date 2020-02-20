$(document).ready(function(){
	$('.x_panel').find('.x_content #kecamatan').on("change", function(){
		var kecamatan = '';
		$('.x_panel').find('.x_content #data_dpc').val($(this).val());
		var dpc = $('.x_panel').find('.x_content #data_dpc').val();
		var arr_dpc = dpc.split(",");
		$.each(arr_dpc, function(index, value){
			if(index < (arr_dpc.length-1)){
				kecamatan += value+',';
			}else{
				kecamatan += value;
			}
		});
		$.get("/misc/kegiatan/kelurahan", {kecamatan}, function(data,status){
			data = data.substring(0, (data.length-1));
			var arrayData = data.split('|');
			$(".x_panel").find('.x_content #kelurahan #opt_kelurahan').remove();
			$.each(arrayData, function(index, value){
				var arrayOpt = value.split('_');
				$(".x_panel").find('.x_content #kelurahan').append("<option id='opt_kelurahan' value='"+arrayOpt[0]+"'>"+arrayOpt[1]+"</option>");
			});
		}).fail(function(){
			$(".x_panel").find('.x_content #kelurahan #opt_kelurahan').remove();
		});
	});

	$('.x_panel').find('.x_content #tampil_dpra').on("ifChecked", function(){
		var self = $(this);
		var dpc = $(".x_panel").find(".x_content #kecamatan").val();
		if(!dpc){dpc = '';}
		if(self.val() == 'ya' && !dpc){
			alert("Pilih Dpc untuk menampilkan Teritori Dpra");
		}
	});


	$('.x_panel').find('.x_content #cari_data').on("click", function(){
		var bulan = $(".x_panel").find(".x_content #bulan").val();
		var bidang = $(".x_panel").find(".x_content #bidang").val();
		if(!bidang){bidang = '';}
		var kategori = $(".x_panel").find(".x_content #kategori").val();
		if(!kategori){kategori = '';}
		var dpc = $(".x_panel").find(".x_content #kecamatan").val();
		if(!dpc){dpc = '';}
		var dpra = $(".x_panel").find(".x_content #kelurahan").val();
		if(!dpra){dpra = '';}
		var tampil_dpra = '';
		$(".x_panel").find(".x_content #tampil_dpra").each(function(){
			var self = $(this);
			if(self.is(':checked')){
				tampil_dpra = self.val();
			}
		});

		$(location).attr("href","?my1="+bulan+"&bidang="+bidang+"&kategori="+kategori+"&dpc="+dpc+"&tampil_dpra="+tampil_dpra+"&dpra="+dpra);
	});
});
