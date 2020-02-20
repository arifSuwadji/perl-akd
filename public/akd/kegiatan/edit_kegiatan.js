$(document).ready(function() {
	setTimeout(function(){
		$('#wizard').smartWizard();

		$('#wizard_verticle').smartWizard({
			transitionEffect: 'slide'
		});

		$('.buttonNext').addClass('btn btn-round btn-primary');
		$('.buttonPrevious').addClass('btn btn-round btn-info');
		$('.buttonFinish').addClass('btn btn-round btn-success');

		$('#detail_kegiatan').parsley().on('field:validated', function() {
			var ok = $('.parsley-error').length === 0;
			$('.peringatan').toggleClass('hidden', ok);
		}).on('form:submit', function() {
			return true;
		});

		$('.buttonFinish').on("click", function(){
			var bidang = $('.x_panel').find('.x_content #bidang').val();
			var kategori = $('.x_panel').find('.x_content #kategori').val();
			var kegiatan = $('.x_panel').find('.x_content #kegiatan').val();
			var deskripsi = $('.x_panel').find('.x_content #deskripsi').val();
			var dpd = $('.x_panel').find('.x_content #dpd').val();
			var kecamatan = $('.x_panel').find('.x_content #kecamatan').val();
			var kelurahan = $('.x_panel').find('.x_content #kelurahan').val();
			var rw = $('.x_panel').find('.x_content #rw').val();
			var foto = $('.x_panel').find('.x_content #foto_upload').val();
			$('.info').addClass('hidden');
			$('.peringatan').addClass('hidden');
			if(!bidang){
				$('.x_panel').find('.x_content #bidang').prop('required',true);
				$(".peringatan").find("#keterangan").text("Data Kegiatan - Bidang belum dipilih.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!kategori){
				$('.x_panel').find('.x_content #kategori').prop('required',true);
				$(".peringatan").find("#keterangan").text("Data Kegiatan - Kategori belum dipilih.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!kegiatan){
				$('.x_panel').find('.x_content #kegiatan').prop('required',true);
				$(".peringatan").find("#keterangan").text("Data Kegiatan - Kegiatan belum diisi.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!deskripsi){
				$('.x_panel').find('.x_content #deskripsi').prop('required',true);
				$(".peringatan").find("#keterangan").text("Data Kegiatan - Deskripsi belum diisi.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!dpd){
				$('.x_panel').find('.x_content #dpd').prop('required',true);
				$(".peringatan").find("#keterangan").text("Lokasi Kegiatan - DPD belum dipilih.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!kecamatan){
				$('.x_panel').find('.x_content #kecamatan').prop('required',true);
				$(".peringatan").find("#keterangan").text("Lokasi Kegiatan - Kecamatan belum dipilih.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!kelurahan){
				$('.x_panel').find('.x_content #kelurahan').prop('required',true);
				$(".peringatan").find("#keterangan").text("Lokasi Kegiatan - Kelurahan belum dipilih.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else if(!rw){
				$('.x_panel').find('.x_content #rw').prop('required',true);
				$(".peringatan").find("#keterangan").text("Lokasi Kegiatan - RW belum dipilih.");
				$('.info').addClass('hidden');
				$('.x_panel').find("#detail_kegiatan").submit();
			}else{
				var op = $("<input>").attr("type", "hidden").attr("name", "op").val("edit");
				$(".x_panel").find("#detail_kegiatan").append($(op));
				$('.x_panel').find("#detail_kegiatan").submit();
			}
		});
	},10);

	$('.x_panel').find('.x_content #kategori').select2({ allowClear: true});

	$('.x_panel').find('.x_content #bidang').select2({ allowClear: true});

	$('.x_panel').find('.x_content #level').select2({ allowClear: true});

	$('.x_panel').find('.x_content #kategori').on("change", function(){
		var id = $(this).val();
		$('.peringatan').addClass('hidden');
/* tidak dipakai karena kegiatan input bukan dropdown
		$.get("/misc/kegiatan/sub_kategori", {id}, function(data,status){
			data = data.substring(0, (data.length-1));
			var arrayData = data.split('|');
			$(".x_panel").find('.x_content #kegiatan #opt_kegiatan').remove();
			$.each(arrayData, function(index, value){
				var arrayOpt = value.split('_');
				$(".x_panel").find('.x_content #kegiatan').append("<option id='opt_kegiatan' value='"+arrayOpt[0]+"'>"+arrayOpt[1]+"</option>");
			});
		}).fail(function(){
			$(".x_panel").find('.x_content #kegiatan #opt_kegiatan').remove();
		});*/
	});

	$('.x_panel').find('.x_content #bidang').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('.x_panel').find('.x_content #dpd').select2({ allowClear: true});

	$('.x_panel').find('.x_content #dpd').on("change", function(){
		$('.peringatan').addClass('hidden');
		var dpd = $(this).val();
		$.get("/misc/kegiatan/kecamatan", {dpd}, function(data,status){
			data = data.substring(0, (data.length-1));
			var arrayData = data.split('|');
			$(".x_panel").find('.x_content #kecamatan #opt_kecamatan').remove();
			$.each(arrayData, function(index, value){
				var arrayOpt = value.split('_');
				$(".x_panel").find('.x_content #kecamatan').append("<option id='opt_kecamatan' value='"+arrayOpt[0]+"'>"+arrayOpt[1]+"</option>");
			});
		}).fail(function(){
			$(".x_panel").find('.x_content #kecamatan #opt_kecamatan').remove();
		});
	});

	$('.x_panel').find('.x_content #kecamatan').select2({ allowClear: true});

	$('.x_panel').find('.x_content #kecamatan').on("change", function(){
		var kecamatan = $(this).val();
		$('.peringatan').addClass('hidden');
		$.get("/misc/kegiatan/kecamatan", {kecamatan}, function(data,status){
			$('.x_panel').find('.x_content #nama_kecamatan').val(data);
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

	$('.x_panel').find('.x_content #kelurahan').select2({ allowClear: true});

	$('.x_panel').find('.x_content #kelurahan').on("change", function(){
		var kelurahan = $(this).val();
		if(kelurahan){
			$('.peringatan').addClass('hidden');
			$.get("/misc/kegiatan/kelurahan", {kelurahan}, function(data,status){
				$('.x_panel').find('.x_content #nama_kelurahan').val(data);
			});
			setTimeout(function(){
				var nama_kecamatan = $('.x_panel').find('.x_content #nama_kecamatan').val();
				var nama_kelurahan = $('.x_panel').find('.x_content #nama_kelurahan').val();
				myGeoPositionGeoPicker({
					startAddress     : nama_kelurahan+' '+nama_kecamatan,
					returnFieldMap   : {
						'koordinat' : '<LAT>,<LNG>',
						'alamat' : '<STREET>',   /* ...or <COUNTRY>, <STATE>, <DISTRICT>,
									<CITY>, <SUBURB>, <ZIP>, <STREET>, <STREETNUMBER> 
						'geoposition1d' : '<ADDRESS>'*/
					}
				});
			},100);
		}
	});

	$('.x_panel').find('.x_content #rw').select2({ allowClear: true});

	$('.x_panel').find('.x_content #rw').on("change", function(){
		$('.peringatan').addClass('hidden');
	});

	$('.x_panel').find('.x_content #target').priceFormat({prefix:'', centsLimit: 0, thousandsSeparator:','});

	$('.x_panel').find('.x_content #realisasi').priceFormat({prefix:'', centsLimit: 0, thousandsSeparator:','});
});
