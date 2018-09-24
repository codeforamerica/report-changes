var directUpload = (function () {
    return {
        init: function () {
            $('input[type=file]').each(function (index, fileInput) {
                const url = fileInput.dataset.directUploadUrl;

                var uploadBtn = document.getElementById('file-upload');
                uploadBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    fileInput.click();
                });

                fileInput.addEventListener('change', function (e) {
                    for(var i=0,file;file=this.files[i];i++) {
                        $('.verification-upload-icon').hide();
                        const upload = new ActiveStorage.DirectUpload(file, url);
                        upload.create(function (error, blob) {
                            var hiddenInputContext = {inputValue: blob.signed_id, inputName: fileInput.name};
                            var hiddenInputHtml = HandlebarsTemplates['hidden_input'](hiddenInputContext);
                            $('form').append(hiddenInputHtml);

                            var context = {filename: blob.filename, signed_id: blob.signed_id};
                            var docPreviewHtml = HandlebarsTemplates['doc_preview'](context);
                            $('.uploaded-files').append(docPreviewHtml);
                        });
                    };
                    fileInput.value = null;
                });
            });
        }
    }
})();

$(document).ready(function () {
    directUpload.init();
});
