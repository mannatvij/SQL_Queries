USE FileSystemProject;
GO
IF OBJECT_ID('FileSystem', 'U') IS NOT NULL
    DROP TABLE FileSystem;
GO

-- Create the table
CREATE TABLE FileSystem (
    NodeID INT PRIMARY KEY,
    NodeName VARCHAR(100),
    ParentID INT,
    SizeBytes INT
);
GO
--Inserting in the table
INSERT INTO FileSystem (NodeID, NodeName, ParentID, SizeBytes) VALUES
(1, 'Documents', NULL, NULL),
(2, 'Pictures', NULL, NULL),
(3, 'File1.txt', 1, 500),
(4, 'Folder1', 1, NULL),
(5, 'Image.jpg', 2, 1200),
(6, 'Subfolder1', 4, NULL),
(7, 'File2.txt', 4, 750),
(8, 'File3.txt', 6, 300),
(9, 'Folder2', 2, NULL),
(10, 'File4.txt', 9, 250);
GO

--SQL Query: Recursive expression for Folder System
WITH FolderTree AS (
    -- Base: each node starts by referring to itself
    SELECT 
        NodeID AS RootID,
        NodeID AS ChildID,
        SizeBytes
    FROM FileSystem

    UNION ALL

    -- Recursive: pull in all children of each node
    SELECT 
        ft.RootID,
        fs.NodeID AS ChildID,
        fs.SizeBytes
    FROM FolderTree ft
    JOIN FileSystem fs ON fs.ParentID = ft.ChildID
)

-- Final: sum sizes of all files under each root folder or file
SELECT 
    fs.NodeID,
    fs.NodeName,
    SUM(ISNULL(ft.SizeBytes, 0)) AS sizeBytes
FROM FolderTree ft
JOIN FileSystem fs ON fs.NodeID = ft.RootID
GROUP BY fs.NodeID, fs.NodeName
ORDER BY fs.NodeID;