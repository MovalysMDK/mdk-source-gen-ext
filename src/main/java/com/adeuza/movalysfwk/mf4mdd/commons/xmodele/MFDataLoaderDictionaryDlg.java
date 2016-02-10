/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Delegate for managing dataloaders in dictionary
 * @author lmichenaud
 *
 */
public class MFDataLoaderDictionaryDlg {

	/**
	 * Data Loaders
	 */
	private Map<String,MDataLoader> dataLoaders = new HashMap<String,MDataLoader>();
	
	/**
	 * Register a dataloder
	 * @param p_oDataLoader dataloader to register
	 */
	public void registerDataLoader(MDataLoader p_oDataLoader ) {
		this.dataLoaders.put(p_oDataLoader.getName(), p_oDataLoader);
	}

	/**
	 * Get All dataloaders
	 * @return dataloaders
	 */
	public Collection<MDataLoader> getAllDataLoaders() {
		return this.dataLoaders.values();
	}
	
	/**
	 * Return the <code>DataLoader</code> that match to the current name send as parameter.
	 * @param p_sName the name of the DataLoader
	 * @return object of type <code>MDataLoader</code>
	 */
	public MDataLoader getDataLoader(String p_sName) {
		return this.dataLoaders.get(p_sName);
	}
}
