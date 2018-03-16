// libntfForGo.h
#ifdef __cplusplus
extern "C" {
#endif
	char const* ConvertCharArrayToLPCWSTR(char* path);
	
	unsigned int CreateJunction(char* link, char* target);
	_Bool IsJunction(char* path);
	unsigned int GetJunctionTarget(char* path, char* target, int site);
	unsigned int DeleteJunction(char* path);
#ifdef __cplusplus
}
#endif