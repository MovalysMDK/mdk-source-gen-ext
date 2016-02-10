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
package com.adeuza.movalysfwk.mf4mdd.html5.xmodele;

import java.util.Collection;

import com.a2a.adjava.languages.html5.xmodele.MH5Dictionary;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFDataLoaderDictionaryDlg;
import com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary;

public class MF4HDictionary extends MH5Dictionary implements MFModelDictionary {

	/**
	 * Dataloader dictionary delegate
	 */
	private MFDataLoaderDictionaryDlg dataLoaderDlg = new MFDataLoaderDictionaryDlg();
			
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary#registerDataLoader(com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MDataLoader)
	 */
	@Override
	public void registerDataLoader(MDataLoader p_oDataLoader) {
		this.dataLoaderDlg.registerDataLoader(p_oDataLoader);
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary#getAllDataLoaders()
	 */
	@Override
	public Collection<MDataLoader> getAllDataLoaders() {
		return this.dataLoaderDlg.getAllDataLoaders();
	}

	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mf4mdd.commons.xmodele.MFModelDictionary#getDataLoader(java.lang.String)
	 */
	@Override
	public MDataLoader getDataLoader(String p_sName) {
		return this.dataLoaderDlg.getDataLoader(p_sName);
	}

}
