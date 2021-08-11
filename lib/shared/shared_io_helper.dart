import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_archive/flutter_archive.dart';

const lineSeparator = '╪';

class IoHelper {
  static Directory _directory;
  static Directory _debugSelectedDirectoryParent;
  static int _debugSelectedDirectoryIndex;

  static Future<Directory> getDirectory() async{
    await _initDirectory();
    return _directory;
  }

  static Future _initDirectory() async{
    if (_directory == null){
      _directory = await getApplicationDocumentsDirectory();
      _debugSelectedDirectoryParent = _directory;
      _debugSelectedDirectoryIndex = 0;
    }
  }

  static Future<String> printFileList({Directory dir, int level = 0}) async{
    await _initDirectory();
    try{
      String temp = '';

      if (dir == null){
        dir = _directory;
      }

      // int index = 0;
      final fsEntities = dir.listSync();
      fsEntities.sort((a,b) => a.path.compareTo(b.path));
      final selectedDirSorted = _debugSelectedDirectoryParent.listSync()..sort((a,b) => a.path.compareTo(b.path));
      for (int i = 0; i < fsEntities.length; i++){
        FileSystemEntity element = fsEntities[i];

        temp += (' ' * (level * 4)) + element.path.split('/').last;
        if (element.path == selectedDirSorted[_debugSelectedDirectoryIndex].path)
          temp += ' (selected) ';
        temp += '\n';
        if (element is Directory){
          temp += await printFileList(dir: element, level:(level + 1));
        }

        // index += 1;
      }

      return temp;
    }
    catch (e) {
      print('Cannot print file list.');
      print(e);
      return null;
    }
  }

  static Future debugMoveSelect(int direction) async{
    final ls = _debugSelectedDirectoryParent.listSync();
    ls.sort((a,b) => a.path.compareTo(b.path));
    if (direction == -1){ // down
      if (_debugSelectedDirectoryIndex == ls.length - 1)
        return null;
      _debugSelectedDirectoryIndex += 1;
    }
    else if (direction == 1){ // up
      if (_debugSelectedDirectoryIndex == 0)
        return null;
      _debugSelectedDirectoryIndex -= 1;
    }
  }
  static Future debugDirectoryDirection(int direction) async{
    final ls = _debugSelectedDirectoryParent.listSync()..sort((a,b) => a.path.compareTo(b.path));
    if (direction == -1){ // left
      if (_debugSelectedDirectoryParent.path != _directory.path) {
        _debugSelectedDirectoryParent = ls[_debugSelectedDirectoryIndex].parent.parent;
        _debugSelectedDirectoryIndex = 0;
        print('hit');
      }
    }
    else if (direction == 1){ // right
      if (ls[_debugSelectedDirectoryIndex] is Directory) {
        _debugSelectedDirectoryParent = ls[_debugSelectedDirectoryIndex] as Directory;
        _debugSelectedDirectoryIndex = 0;
      }
    }
  }
  static Future debugDeleteSelected() async{
    try{
      (_debugSelectedDirectoryParent.listSync()..sort((a,b) => a.path.compareTo(b.path)))[_debugSelectedDirectoryIndex].delete(
        recursive: true
      );
      _debugSelectedDirectoryParent = _directory;
      _debugSelectedDirectoryIndex = 0;
      return true;
    }
    catch(e) {
      print("Cannot delete file.");
      print(e.toString());
      return null;
    }
  }
  static Future<String> debugOpenSelectedAsString() async {
    return (((_debugSelectedDirectoryParent.listSync())..sort((a,b) => a.path.compareTo(b.path)))[_debugSelectedDirectoryIndex] as File).readAsString();
  }

  static Future<String> read(String filename) async {
    try {
      await _initDirectory();
      File file = File("${_directory.path}/$filename");
      String temp = await file.readAsString();
      print("Read string from ${_directory.path}/$filename");
      return temp;
    } catch (e) {
      print("Cannot read file.");
      print(e.toString());
      return null;
    }
  }

  // todo: change to Future<String> where it returns the full directory path
  static Future<List<FileSystemEntity>> children(String folderPath) async{
    try {
      await _initDirectory();
      return Directory("${_directory.path}/$folderPath").listSync();
    }
    catch(e){
      print('Cannot get children of $folderPath');
      print(e.toString());
      return null;
    }
  }
  static Future<bool> write(String relativePathAndName, String lines) async {
    try {
      await _initDirectory();
      File file = File("${_directory.path}/$relativePathAndName");

      await file.writeAsString(lines);

      print("Written to string at ${_directory.path}/$relativePathAndName");
      return true;
    } catch (e) {
      print("Cannot save file.");
      print(e.toString());
      return false;
    }
  }
  static Future<void> delete(String filename) async {
    try {
      await _initDirectory();
      File file = File("${_directory.path}/$filename");
      await file.delete();
      print("Deleted file at ${_directory.path}/$filename");
    } catch (e) {
      print("Cannot delete file.");
      print(e.toString());
    }
  }
  static Future<bool> clearFolder(String pathToFolder) async {
    try {
      await _initDirectory();
      final files = Directory("${_directory.path}/$pathToFolder").listSync();
      for (FileSystemEntity fse in files){
        await fse.delete(recursive: true);
      }
      print("Cleared folder at ${_directory.path}/$pathToFolder");
      return true;
    } catch (e) {
      print("Cannot clear folder at ${_directory.path}/$pathToFolder");
      print(e.toString());
      return false;
    }
  }
  static Future<String> getFullPath(String filename) async {
    try {
      await _initDirectory();
      return "${_directory.path}/$filename";
    } catch (e) {
      print("Cannot get file path.");
      print(e.toString());
      return null;
    }
  }
  static Future<String> zipFromFiles(List<File> files, String zipFileName, {Directory directory}) async{
    try {
      if (directory == null){
        await _initDirectory();
        directory = _directory;
      }
      await ZipFile.createFromFiles(
          sourceDir: directory, files: files, zipFile: File("${directory.path}/$zipFileName"));
      return "${_directory.path}/$zipFileName";
    } catch (e) {
      print('Cannot zip file.');
      print(e);
      return null;
    }
  }
  static Future<bool> zipFromFolder(Directory folder, File finalZipFile) async{
    try {
      await ZipFile.createFromDirectory(
        zipFile: finalZipFile,
        sourceDir: folder
      );
      return true;
    } catch (e) {
      print('Cannot zip folder.');
      print(e);
      return false;
    }
  }
  static Future<File> copy(File f, String newFileName, {Directory directory}) async {
    try {
      if (directory == null){
        await _initDirectory();
        directory = _directory;
      }
      return f.copy(directory.path + '/$newFileName');
    } catch (e) {
      print("Cannot copy file.");
      print(e);
      return null;
    }
  }
  static Future<bool> newFolder(String pathFile) async {
    try{
      await _initDirectory();
      final d = Directory(_directory.path +'/'+pathFile);
      if (!(await d.exists()))
        await d.create(recursive: true);
      return true;
    }
    catch (e){
      print('Cannot create new folder at $pathFile');
      print(e);
      return false;
    }
  }
}
