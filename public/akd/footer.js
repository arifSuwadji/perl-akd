$(document).ready(function(){
	setTimeout(function(){
		$(".x_panel").find("#content_hide").addClass('collapse');
	},10);

	$('input.flat2').iCheck({
		checkboxClass: 'icheckbox_flat-green',
		radioClass: 'iradio_flat-green'
	});

	$('.single_date').daterangepicker({
		singleDatePicker: true,
		calender_style: "picker_4",
		format: 'DD-MM-YYYY',
	});

	$('.single_date2').daterangepicker({
		singleDatePicker: true,
		calender_style: "picker_4",
		format: 'DD-MM-YYYY',
	});

	$('.select2').select2({ allowClear: true});

	$("#tampilkan").select2();

	$("#tampilkan").on("change", function(){
		var id = $(this).data('id');
		var tampilkan = $(this).val();
		if(id){
			$(location).attr("href", "?_per="+tampilkan+"&"+id);
		}else{
			$(location).attr("href", "?_per="+tampilkan);
		}
	});

	$('.month').datepicker({
		format: "mm-yyyy",
		minViewMode: 1,
		maxViewMode: 2,
		autoclose: true
	});
});
