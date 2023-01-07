# flowerbasket
Ciceksepeti e-commerce clone school project


<table>
<tr>
  <td> <img src="https://user-images.githubusercontent.com/70816926/211141416-6a294289-5ca7-48f1-a337-ef188e1040c7.jpeg" width="350"/> </td>
  <td> <img src="https://user-images.githubusercontent.com/70816926/211141943-729938f7-af10-45fa-bec0-f2220c81aab2.jpeg" width="350"/> </td>
  <td> <img src="https://user-images.githubusercontent.com/70816926/211141415-215e6308-4a87-4182-9f40-e0273e8ab0f8.jpeg" width="350"/> </td>
<tr>
<table>




<details><summary>CLICK For Documentation</summary>
## Diagram
![Diagram](https://raw.githubusercontent.com/0xberkay/flowerbasket/main/diagram.png)

## Database Setup

The database files can be found in the `database` folder. You can either use the `CicekSepeti-2022-12-31-22-33.dacpac` file or upload the `CicekSepeti-202221231-22-35-32.bak` file to the MSSQL server as a backup.

## Backend Installation - Source Code

1. Install Go from [go.dev](https://golang.org/doc/install).
2. In the `backend` folder, open `go.mod` and download the required libraries.
3. Once the libraries are downloaded, you can proceed to the execution phase.

## Backend Setup - Bin File

1. Download the appropriate `bin` folder from the `relases`.
2. Once the bin file is downloaded, you can proceed to the execution phase.

## Operation Phase

To get help with the available commands, use the `-h` flag.

To run the `bin` file or `main.go` file, use the following command with the relevant parameters:



go run -password yourPass -server yourDatabaseServer -user yourUserName -database yourDatabaseName -mail yourMail -mailpass yourMailPassword -mailserver yourMailServer

The server will be running at port `3000`.

## Interface Setup - Bin File

1. Download and run the appropriate `bin` folder from the `interface-builds` folder.
2. Make sure the backend is running before starting the interface.
3. The interface works at `127.0.0.1:3000`.

## Interface Setup - Source Code

1. Install Flutter from the [official documentation](https://flutter.dev/docs/get-started/install).
2. In the `interface` folder, open `pubspec.yaml` and download the required libraries with `flutter pub get`.
3. To run the interface, use the `flutter run` command.
4. To create a `bin` file for the target operating system, use the `flutter build targetOS` command.


### Admin

Username: `admin`
Password: `admin`