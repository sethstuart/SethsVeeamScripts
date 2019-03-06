#This is Seth's Veeam/Windows Server Drive FreeSpace Checker!
#It's function is to remotely access Windows based Veeam repositories and return data on the attached drives. 
#It is written entirely in powershell and is farily simple to follow.
#
Param(                                                      #Start of the script. I define a parameter that I pass to the main function.
     [Parameter(ValueFromPipeline=$true, Mandatory=$false)] #This line prefixes the next, specifying that I expect a value from the pipline, and that I don't have to see that value. 
     [Array] $Computers                                     #This is where I define the value specifed above. Here I identify the array Computers. It is an array of the computers I want to check. 
)

$SystemList = get-content systems.txt                          #This is where the Computers array comes from. I get the content of systems.txt and assign it to SystemList
$Computers = $SystemList.Split(',')                         #I take SystemList and I split it into multiple objects using commas as the delineator. The puntuation between the single quotes in the parenthesis is the character used to delineate. "Split.(',')"
get-date | add-content "results.txt"     #Before you run Get-DirFreeSize you need to get the date and add it to our output file. The file path here needs to be changed depending on where this is being ran from. 


Function Class-Size($size){	                                #This function is called later to convert the bit values given to us by Get-Volume to meaningful values of MB, GB, and TB. 

IF($size -ge 1TB)
	{
	"{0:n2}" -f  ($size / 1TB) + " TB"                      #The "{0:n2}" value is knows as Standard numeric formatting for .NET strings. For more information see https://docs.microsoft.com/en-us/dotnet/standard/base-types/custom-numeric-format-strings
	}
ELSEIF($size -ge 1GB)
	{
	"{0:n2}" -f  ($size / 1GB) + " GB"
	}
ELSEIF($size -ge 1MB)
	{
	"{0:n2}" -f  ($size / 1MB) + " MB"
	}
ELSE
	{
	"{0:n2}" -f  ($size / 1KB) + " KB"
	}
} 

function Get-DirFreeSize {                                  #This is the primary function that does all the work. It's a bit messy so I will attempt to explain it as well as I can. 
Param(                                                      #Here I pass the existing Computers array to the funtion
     [Array]$Computers                                      #I define that it is an array and it is called $Computers. 
) 
Foreach($Computer in $Computers){                           #This loop runs once for each object in the computers array.  https://ss64.com/ps/foreach.html
	 $ErrorActionPreference = "SilentlyContinue"            #If there is an error, dont stop the script, keep it running. 

     $VolumeInfo = Invoke-Command -ComputerName $Computer -ScriptBlock {		#This is the heavylifter. I define a local object called VolumeInfo. It contains information about the volumes. It contains the result of the remote invoke. This uses the DNS name of the system provided in Computers, remotely runs a get-volume, and filters out volumes that do not show as fixed (this will exclude USB disks and DVD drives), and the System Reserved partiton. 
	  (Get-Volume | where { $_.driveType -like "Fixed" -and $_.FileSystemLabel -notlike "System Reserved" }) #Thanks to Nick Hill to helping me with the sorting and selection logic!!
         }
		add-content "results.txt" $Computer 		#I add the name of the device I are gathering drive information from to resulting log file
	   for($a = 0; $a -lt $VolumeInfo.Count; $a++){                                         #This loop counts how many objects are in VolumeInfo, and runs for that many times. 
		  $TempRepoData = @()                                                               #Splat a local array
		  $Result = "" | Select DriveLetter,FSLabel,Size,FreeSpace                          #Define an empty inline variable and select the properties I want. 
	      $Result.DriveLetter = $VolumeInfo[$a].DriveLetter                                 #Assign the drive letter of the current volume, using the loop structure and the loop variable to select which object in the array I want to get proerties from
	      $Result.FSLabel = $VolumeInfo[$a].FileSystemLabel                                 #Same as pervious line, but with FSLable
	      $Result.Size = Class-Size $VolumeInfo[$a].Size                                    #Same as previous, however before I assign the value I pass it through the class-size function to get a meaningful result 
	      $Result.FreeSpace = Class-Size $VolumeInfo[$a].SizeRemaining                      #Same as previous
	      $TempRepoData += $Result                                                          #I take the individual Result object that contains the data of one volume from the current computer and append it to the TempRepoData array
		  add-content "results.txt" $TempRepoData		  #I append the Array to the end of results.txt
		  $TempRepoData
		   }
	 }
}

Get-DirFreeSize -Computers $Computers           #This line runs the script. It calls the function Get-DirFreeSize and passes it the parameter Computers.

#To add more systems to the script, add to files.txt. Invoke-Command can use DNS names or IP adresses to connect to remote devices. I recommend using DNS names. See the below line as to how this should look. For the last entry in the list leave off the comma. 
#systems.txt example: PHX0-VCCVBR3,PHX0-VCCPVBR04,PHX0-VCCPVBR05,PHX0-VCCPVBR07