template "GUID Partition Table"

// X-Ways Software Technology AG
// To be applied to sector 0 of a physical hard disk with GPT partitioning.

description "Contains GUID partition table"
applies_to disk
sector-aligned
requires 512 "45 46 49 20 50 41 52 54"

begin

	move 446

	section	"Protective MBR"
		uint8		"Boot Indicator"
		hex 1		"Starting Head"
		hex 1		"Starting Sector"
		hex 1		"Starting Cylinder"
		hex 1		"System ID (Should be 1xEE)"
		hex 1		"Ending Head"
		hex 1		"Ending Sector"
		hex 1		"Ending Cylinder"
		uint32		"Starting LBA"
		uint32		"Size in LBA"
	endsection
		
	move 50
	
	section	"GUID Partition Table Header"
		hex 8 		"Signature (must be 45[..]54)"
		hex 4		"Revision No"
		uint32		"Header Size (should be 92)"
		hexadecimal uint32	"Header CRC32"
		move 4
		int64		"Primary LBA (should be 1)"
		int64		"Backup LBA"
		int64		"First Usable LBA"
		int64		"Last Usable LBA"
		hex 16 		"Disk GUID"
		move -16
		GUID		"Disk GUID"
		int64		"Partition Entry LBA (should be 2)"
		uint32		"MaxNo of Partition Entries"
		uint32		"Size of Partition Entry"
		hexadecimal uint32	"Partition Entry Array CRC32"
	endsection

	move 420

	numbering 1
	{
	section	"GUID Partition Table Entry #~"
	
		hex 16 		"Partition Type GUID"
		move -16
		GUID		"Partition Type GUID"
		hex 16		"Unique Partition GUID"
		move -16
		GUID		"Unique Partition GUID"
		int64		"Starting LBA"
		IfEqual "Starting LBA" 0
			ExitLoop
		EndIf
		int64		"Ending LBA"
		hex 8 		"Attribute Bits"
		string16 36	"Partition Name"
	}[128]
	endsection
end