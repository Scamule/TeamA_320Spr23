import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


class EmailSender:
    def __init__(self, smtp_server, smtp_port, username, password):
        self.smtp_server = smtp_server
        self.smtp_port = smtp_port
        self.username = username
        self.password = password

    def send_email(self, sender_email, receiver_email, subject, message):
        # Create a MIMEMultipart object to represent the email message
        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = receiver_email
        msg['Subject'] = subject

        # Attach the message as plain text to the MIMEMultipart object
        msg.attach(MIMEText(message, 'plain'))

        # Create an SMTP server instance and start TLS encryption
        server = smtplib.SMTP(self.smtp_server, self.smtp_port)
        server.starttls()

        # Log in to the SMTP server using the provided username and password
        server.login(self.username, self.password)

        # Send the email by converting the MIMEMultipart object to a string
        server.sendmail(sender_email, receiver_email, msg.as_string())

        # Close the connection to the SMTP server
        server.quit()
