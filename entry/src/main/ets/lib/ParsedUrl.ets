import map from '@hms.core.map.map';

export class ParsedUrl {
  protocol: string;
  hostname: string;
  pathname: string;
  //searchParams: { [key: string]: string };
  //searchParams: string[] = []
  private searchParams: Map<string, string> = new Map();

  constructor(protocol: string, hostname: string, pathname: string, searchParams: Map<string, string>) {
    this.protocol = protocol;
    this.hostname = hostname;
    this.pathname = pathname;
    this.searchParams = searchParams;
  }

  static parse(url: string): ParsedUrl | null {
    // Regular expression to parse the URL components
    const urlRegex = /^(https?:\/\/)?([^\/\s]+)(\/[^?#]*)?(\?[^#]*)?/;
    const matches = url.match(urlRegex);

    if (!matches) {
     // throw new Error("Invalid URL");
      return null
    }

    const protocol = matches[1] || "";
    const hostname = matches[2] || "";
    const pathname = matches[3] || "";
    const search = matches[4] || "";

    // Parse query parameters
    const searchParams: Map<string, string> = new Map();
    if (search.startsWith("?")) {
      const queryString = search.substring(1);
      const pairs = queryString.split("&");
      pairs.forEach(pair => {
        const pAr = pair.split("=");
        if (pAr.length > 1) {
          searchParams[decodeURIComponent(pAr[0])] = decodeURIComponent(pAr[1] || "");
        }
      });
    }

    return new ParsedUrl(protocol, hostname, pathname, searchParams);
  }
}
