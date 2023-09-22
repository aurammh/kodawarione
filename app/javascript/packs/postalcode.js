$(function () {
  let apiPostalCode;
  setPostalCode();
  /*postal code insert*/
  $("#postalcode").on("keyup", function (event) {
    let postal_code = $(this).val();
    if (postal_code.length == 7) {
      setPostalCode(postal_code);
    }
    if (postal_code.length == 0) {
      $("#region").val("");
      $("#prefecture").val("");
      $("#city").val("");
      $("#region_id").val("");
      $("#prefecture_id").val("");
      $("#address").val("");
      $("#display_address").val("");
      // displayAddress();
    }
  });

  /*address insert*/
  $("#address").on("keyup", function (event) {
    displayAddress();
  });

  /*copy postal code info from company's basic info*/
  $("#address-copy").on("click", copyAddress);
});

/*generate postal code*/
function setPostalCode(postal_code) {
  postal_code = postal_code || $("#postalcode").val();
  if (postal_code.length == 7) {
    $.ajax({
      type: "get",
      url: "https://maps.googleapis.com/maps/api/geocode/json",
      crossDomain: true,
      dataType: "json",
      data: {
        address: postal_code,
        language: "ja",
        sensor: false,
        components: "country:jp",
        key: "AIzaSyCvM8E0Z3KZb8bwPxx7pBSaAVW3NoBWSNQ",
      },
      success: function (resp) {
        if (resp.status == "OK") {
          let address_data = resp.results[0].address_components;
          if (address_data.length > 1) {
            apiPostalCode = resp.results[0].formatted_address.split(" ")[1];
            $.ajax({
              url:
                "/get_region_name_by_prefecturename/" +
                address_data[address_data.length - 2]["long_name"],
              success: function (data) {
                $("#region").val(data.region_name);
                $("#prefecture").val(
                  address_data[address_data.length - 2]["long_name"]
                );
                $("#city").val(
                  address_data[address_data.length - 3]["long_name"]
                );
                $("#region_id").val(data.region_id);
                $("#prefecture_id").val(data.prefecture_id);
                displayAddress();
              },
            });
          } else {
            alert("日本国内の郵便番号だけ入力してください。");
          }
        } else {
          $("#region").val();
          $("#prefecture").val("");
          $("#city").val("");
          $("#region_id").val();
          $("#prefecture_id").val("");
          displayAddress();
          return false;
        }
      },
      error: function (error) {
        console.log(error);
      },
    });
  }
}
/*get dispaly address*/
function displayAddress() {
  let strText;
  let postal_code = apiPostalCode || "";
  let prefecture_name = $("#prefecture").val() || "";
  let city_name = $("#city").val() || "";
  let address = $("#address").val() || "";
  strText =
    postal_code + " " + prefecture_name + " " + city_name + " " + address;
  $("#display_address").val(strText);
}

/*copy postal code info from company's basic info*/
function copyAddress() {
  let hiddenPostalCode = $("#copy_postal_code").val();
  let hiddenAddress = $("#copy_address").val();

  /*set value to form*/
  let vacancyPostalCode = $("#postalcode");
  let vacancyAddress = $("#address");
  vacancyPostalCode.val(hiddenPostalCode);
  setPostalCode(hiddenPostalCode);
  vacancyAddress.val(hiddenAddress);
  // displayAddress();
}
