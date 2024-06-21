# Copyright (c)
## Developer by the Alghish
### Send Email class

function Send-Email($emailTo, $attachmentpath, $username, $password, $bodyEmail, $subject, $emailFrom, $emailHost, $port, $domain) {

    Try {
        $DateYYYYMM = (Get-Date).ToString("yyyyMMdd")
        $message = new-object Net.Mail.MailMessage;
        $message.From = $emailFrom;
        $message.To.Add($emailTo);
        $message.Subject = $subject;
        $message.Body = $bodyEmail;
        $attachment = New-Object Net.Mail.Attachment($attachmentpath);
        $message.Attachments.Add($attachment);

        $smtp = new-object Net.Mail.SmtpClient($emailHost, $port);
        $smtp.EnableSSL = $false;
        $smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password, $domain);
        $smtp.send($message);

        Log-Message "Info" "Mail $subject Sent $DateYYYYMM"
        $attachment.Dispose();
    }
    Catch {
        Log-Message "Error Email: $($_.Exception.Message)" "Error"         
    }

}

