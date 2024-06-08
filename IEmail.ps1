# Copyright (c)
## Developer by the Alghish
### Send Email class



function Send-Email([string]$emailTo, [string]$attachmentpath, [string]$username, [string]$password, [string]$bodyEmail, [string]$subject, [string]$emailFrom, [string]$emailHost, [string]$port, [string]$domain) {

    Try {
        $DateYYYYMM = (Get-Date).ToString("yyyyMMdd")
        $message = new-object Net.Mail.MailMessage;
        $message.From = $emailFrom;
        $message.To.Add($email);
        $message.Subject = subject;
        $message.Body = bodyEmail;
        $attachment = New-Object Net.Mail.Attachment($attachmentpath);
        $message.Attachments.Add($attachment);

        $smtp = new-object Net.Mail.SmtpClient($emailHost, $port);
        $smtp.EnableSSL = $true;
        $smtp.Credentials = New-Object System.Net.NetworkCredential($username, $password, $domain);
        $smtp.send($message);

        Log-Message "Info" "Mail Sent $DateYYYYMM"
        $attachment.Dispose();
    }
    Catch {
        Log-Message "Error: $($_.Exception.Message)" "Error"         
    }

}
