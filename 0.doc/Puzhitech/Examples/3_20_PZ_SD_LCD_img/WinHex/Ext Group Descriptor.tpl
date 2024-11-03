template "Ext2/Ext3 Group Descriptor"

// Created by Jens Kirschner 
// X-Ways Software Technology AG, 2004-2015

description "Locates the meta blocks for a block group"
applies_to disk
sector-aligned
multiple

begin
	uint32	"Block bitmap block"
	uint32	"Inode bitmap block"
	uint32	"Inode table block"
	uint16	"Free blocks count"
	uint16	"Free Inodes count"
	uint16	"Directories count"
	uint16	"Flags"	
	uint32	"Snapshot excl. bitmap"
	uint16	"Block bitmap checksum"
	uint16 	"Inode bitmap checksum"
	uint16	"Never used inode count"
	uint16 	"Grp desc checksum"	
end
