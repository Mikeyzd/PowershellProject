$ADusers = Get-ADUser -Filter * -Properties 'Name', 'msDS-UserPasswordExpiryTimeComputed'

$ADusers | ForEach-Object {
    $user = $_
    $expiryTime = if ($user.'msDS-UserPasswordExpiryTimeComputed' -eq 9223372036854775807) {
        "The password never expires."
    } elseif ($user.'msDS-UserPasswordExpiryTimeComputed') {
        [datetime]::FromFileTime($user.'msDS-UserPasswordExpiryTimeComputed').ToString("MM/dd/yyyy HH:mm:ss")
    } else {
        "The msDS-UserPasswordExpiryTimeComputed attribute is null or not set."
    }

    [PSCustomObject]@{
        Name = $user.Name
        PasswordExpiryTime = $expiryTime
    }
} | Format-Table -AutoSize


